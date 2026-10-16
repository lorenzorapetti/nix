{
  den.aspects.shell = {
    # `host` is unused but tells den to apply this in host+user context only.
    # deadnix: skip
    host,
    user,
    ...
  }: {
    nixos = {
      sops.secrets.secrets-fish = {
        sopsFile = ../secrets/secrets.fish;
        owner = user.name;
        format = "binary";
        key = "";
      };
    };

    homeManager = {osConfig, ...}: {
      programs.fish = let
        secrets = osConfig.sops.secrets.secrets-fish.path;
      in {
        enable = true;

        binds = {
          "alt-r".command = "tv zellij";
        };

        shellInit = ''
          set -g fish_greeting

          if test -e ${secrets}
              source ${secrets}
          end
        '';

        interactiveShellInit = ''
        '';

        functions = {
          mkcd = {
            body = ''
              mkdir -p $argv
              and cd $argv
            '';
          };

          zn = {
            body = ''
              set path (zoxide query --interactive)

              if test -n "$path"
                  cd $path
                  nvim
              else
                  echo "No path found."
              end
            '';
          };

          re = {
            body = ''
              eval sudo $history[1]
            '';
          };

          nsh = {
            body = ''
              nix shell "nixpkgs#$argv[1]"
            '';
          };
        };
      };
    };
  };
}
