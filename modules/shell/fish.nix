{
  den.aspects.shell = {
    homeManager = {
      programs.fish = {
        enable = true;

        binds = {
          "alt-r".command = "tv zellij";
        };

        shellInit = ''
          set -g fish_greeting
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
        };
      };
    };
  };
}
