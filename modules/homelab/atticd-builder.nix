let
  flake = "github:lorenzorapetti/nix";
in {
  # Nightly build of every host from the latest commit, pushed to the local
  # attic cache so the other machines get cache hits when they switch.
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

    systemd.services.nix-build-hosts = {
      description = "Build all NixOS hosts and push them to Attic";
      after = ["network-online.target" "atticd.service"];
      wants = ["network-online.target"];
      path = [config.nix.package pkgs.git pkgs.jq pkgs.attic-client];

      serviceConfig = {
        Type = "oneshot";
        User = "nix-builder";
        StateDirectory = "nix-build-hosts";
        WorkingDirectory = "/var/lib/nix-build-hosts";
        Environment = "HOME=/var/lib/nix-build-hosts";
        Nice = 19;
        TimeoutStartSec = "8h";
      };

      script = ''
        set -uo pipefail

        attic login local http://${config.services.atticd.settings.listen} "$(cat ${config.sops.secrets.attic-push-token.path})"

        # Pin one commit so every host is built from the same revision
        rev=$(nix flake metadata --json --refresh "${flake}" | jq -r .locked.rev)
        ref="${flake}/$rev"
        echo "Building $ref"

        hosts=$(nix eval --json "$ref#nixosConfigurations" \
          --apply 'c: builtins.filter (h: h != "nixvm") (builtins.attrNames c)' | jq -r '.[]')

        failed=0
        for h in $hosts; do
          echo "==> $h"
          if nix build -o "result-$h" "$ref#nixosConfigurations.$h.config.system.build.toplevel"; then
            attic push local:main "result-$h" || failed=1
          else
            echo "!! build failed for $h"
            failed=1
          fi
        done
        exit $failed
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
