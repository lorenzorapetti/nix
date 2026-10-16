let
  repo = "git@github.com:lorenzorapetti/nix.git";
in {
  # Nightly flake update + build of every host. If every host builds, the
  # updated flake.lock is committed and pushed, and the results are pushed to
  # the local attic cache so the other machines get cache hits when they switch.
  den.aspects.atticd.nixos = {
    config,
    pkgs,
    ...
  }: {
    users.users.nix-builder = {
      isSystemUser = true;
      group = "nix-builder";
    };
    users.groups.nix-builder = {};

    # atticd-atticadm make-token --sub nix-builder --validity 1y --pull main --push main
    sops.secrets.attic-push-token.owner = "nix-builder";

    # Private half of a GitHub deploy key with write access to the repo:
    # ssh-keygen -t ed25519 -N "" -C nix-builder@nyx -f nix-builder
    sops.secrets.nix-builder-deploy-key.owner = "nix-builder";

    programs.ssh.knownHosts."github.com".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl";

    systemd.services.nix-build-hosts = {
      description = "Update the flake, build all NixOS hosts and push them to Attic";
      after = ["network-online.target" "atticd.service"];
      wants = ["network-online.target"];
      path = [config.nix.package pkgs.git pkgs.openssh pkgs.jq pkgs.attic-client];

      environment = {
        HOME = "/var/lib/nix-build-hosts";
        GIT_SSH_COMMAND = "ssh -i ${config.sops.secrets.nix-builder-deploy-key.path} -o IdentitiesOnly=yes";
        GIT_AUTHOR_NAME = "nix-builder";
        GIT_AUTHOR_EMAIL = "nix-builder@nyx";
        GIT_COMMITTER_NAME = "nix-builder";
        GIT_COMMITTER_EMAIL = "nix-builder@nyx";
      };

      serviceConfig = {
        Type = "oneshot";
        User = "nix-builder";
        StateDirectory = "nix-build-hosts";
        WorkingDirectory = "/var/lib/nix-build-hosts";
        Nice = 19;
        TimeoutStartSec = "8h";
      };

      script = ''
        set -euo pipefail

        attic login local http://${config.services.atticd.settings.listen} "$(cat ${config.sops.secrets.attic-push-token.path})"

        # Throwaway checkout owned by this service: reset it to origin/main
        if [ ! -d repo/.git ]; then
          git clone ${repo} repo
        fi
        cd repo
        git fetch origin main
        git checkout -B main origin/main
        git reset --hard origin/main
        git clean -fdx

        nix flake update
        echo "Building $(git rev-parse HEAD) with updated flake.lock"

        hosts=$(nix eval --json ".#nixosConfigurations" \
          --apply 'c: builtins.filter (h: h != "nixvm") (builtins.attrNames c)' | jq -r '.[]')

        failed=0
        for h in $hosts; do
          echo "==> $h"
          if ! nix build -o "../result-$h" ".#nixosConfigurations.$h.config.system.build.toplevel"; then
            echo "!! build failed for $h"
            failed=1
          fi
        done

        if [ "$failed" -ne 0 ]; then
          echo "Some hosts failed to build, not committing or pushing to attic"
          exit 1
        fi

        for h in $hosts; do
          attic push local:main "../result-$h"
        done

        if git diff --quiet flake.lock; then
          echo "flake.lock unchanged, nothing to commit"
        else
          git commit -m "Update flake" flake.lock
          git push origin main
        fi
      '';
    };

    systemd.timers.nix-build-hosts = {
      wantedBy = ["timers.target"];
      timerConfig = {
        OnCalendar = "03:00";
        Persistent = true;
        RandomizedDelaySec = "15m";
      };
    };
  };
}
