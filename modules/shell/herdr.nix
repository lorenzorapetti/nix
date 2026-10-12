{
  perSystem = {pkgs, ...}: {
    packages.herdr-worktree-current = pkgs.writeShellApplication {
      name = "herdr-worktree-current";
      runtimeInputs = with pkgs; [git jq];
      # A failing `herdr workspace list` or a $PWD outside any repo are normal
      # here and must fall through to the git fallback, so leave errexit off.
      bashOptions = ["nounset" "pipefail"];
      text = ''
        # Print the checkout you are looking at, so the lazygit popup knows what "here"
        # means.
        #
        # The focused workspace wins over $PWD, because this runs from a herdr popup and
        # a popup's working directory is herdr's business rather than the workspace's: it
        # can sit on the repo root while you are looking at one of its worktrees. But it
        # only wins within the same repository, so running it straight from a shell can
        # never reach across into whatever repo happens to be on screen.

        herdr=''${HERDR_BIN_PATH:-herdr}

        repo_of() {
          git -C "$1" rev-parse --path-format=absolute --git-common-dir 2>/dev/null
        }

        focused=$("$herdr" workspace list 2>/dev/null \
          | jq -r 'first(.result.workspaces[]
              | select(.focused == true and .worktree != null)
              | .worktree.checkout_path) // empty')

        here=$(repo_of "$PWD")

        if [[ -n $focused ]] && { [[ -z $here ]] || [[ $(repo_of "$focused") == "$here" ]]; }; then
          printf '%s\n' "$focused"
          exit 0
        fi

        git rev-parse --show-toplevel 2>/dev/null
      '';
    };
  };

  den.aspects.shell = {
    homeManager = {
      config,
      lib,
      pkgs,
      self',
      ...
    }: let
      cfg = config.programs.herdr;
      herdr = lib.getExe cfg.package;
      jq = lib.getExe pkgs.jq;

      # Plugin manifests this module wants to have registered. herdr resolves a
      # linked path to its canonical form, so the desired set is keyed on the
      # canonical store path of each configured package.
      desiredPluginManifests = builtins.toJSON (
        lib.mapAttrsToList (_id: plugin: "${toString plugin.package}/herdr-plugin.toml") cfg.plugins
      );

      # Plugin ids registered from the nix store that are no longer configured.
      stalePluginIds = ''
        .result.plugins[]?
        | select((.manifest_path // "") | startswith($store))
        | select((.manifest_path as $p | $desired | index($p)) | not)
        | .plugin_id
      '';

      # Configured plugin manifests that are not registered yet.
      missingPluginManifests = ''
        ($desired - [.result.plugins[]?.manifest_path?])[]
      '';
    in {
      # Backport of nix-community/home-manager#9815; drop once merged upstream
      # (eval will fail with a duplicate option declaration when it lands).
      options.programs.herdr.plugins = lib.mkOption {
        type = with lib.types;
          attrsOf (submodule {
            options.package = lib.mkOption {
              type = either package path;
              description = ''
                The plugin package or a path to the plugin directory. Its top
                level must contain a herdr-plugin.toml manifest; herdr reads
                the plugin id from that manifest when linking.
              '';
            };
          });
        default = {};
        description = ''
          Plugins to register with herdr. Plugins registered outside this
          option, for example with `herdr plugin install`, are left untouched.
        '';
      };

      config = {
        home.packages = [
          self'.packages.herdr-worktree-current
        ];

        programs.herdr = {
          enable = true;
          # binutils 2.46's ld.bfd rejects the zig-built libghostty-vt objects
          # (".eh_frame_hdr refers to overlapping FDEs"); link with lld instead.
          package = pkgs.herdr.overrideAttrs (old: {
            nativeBuildInputs = old.nativeBuildInputs ++ [pkgs.lld];
            env =
              (old.env or {})
              // {
                RUSTFLAGS = "-C link-arg=-fuse-ld=lld";
              };
          });

          plugins = {
            "tdi.worktree-from-linear".package = let
              # The manifest runs bare `node`, and the scripts spawn fzf, git
              # and glow from PATH; pin them so the plugin doesn't depend on
              # whatever the herdr server's environment happens to have.
              node = pkgs.writeShellScript "herdr-linear-node" ''
                export PATH=${lib.makeBinPath (with pkgs; [nodejs fzf git glow])}:$PATH
                exec node "$@"
              '';
            in
              pkgs.stdenvNoCC.mkDerivation {
                pname = "herdr-worktree-from-linear";
                version = "0.6.0";
                src = pkgs.fetchFromGitHub {
                  owner = "tdi";
                  repo = "herdr-worktree-from-linear";
                  rev = "v0.6.0";
                  hash = "sha256-lExUhr0T3oLz1gleEj9iiUTdlcI9s4FSMMgfYaruBSM=";
                };
                installPhase = ''
                  mkdir -p $out
                  cp -r bin lib package.json herdr-plugin.toml $out/
                  substituteInPlace $out/herdr-plugin.toml \
                    --replace-fail 'command = ["node",' 'command = ["${node}",'
                '';
              };
          };
        };

        xdg.configFile."herdr/config.toml".source =
          config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix/dotfiles/herdr/config.toml";

        home.activation.herdrPlugins = lib.hm.dag.entryAfter ["writeBoundary"] ''
          registered="$(${herdr} plugin list --json 2>/dev/null || true)"

          # `plugin list` falls back to the on-disk registry when no server is
          # running, so the diff below still converges. `plugin unlink` needs a
          # reachable server and is therefore deferred (best effort) until the
          # next activation, while `plugin link` persists offline.
          printf '%s' "$registered" \
            | ${jq} -r \
              --arg store "/nix/store/" \
              --argjson desired ${lib.escapeShellArg desiredPluginManifests} '${stalePluginIds}' \
            | while read -r id; do
                [ -n "$id" ] && ${herdr} plugin unlink "$id" >/dev/null 2>&1 || true
              done

          printf '%s' "$registered" \
            | ${jq} -r --argjson desired ${lib.escapeShellArg desiredPluginManifests} '${missingPluginManifests}' \
            | while read -r manifest; do
                [ -n "$manifest" ] && ${herdr} plugin link "$manifest" >/dev/null 2>&1 || true
              done
        '';
      };
    };
  };
}
