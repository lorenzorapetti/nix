{
  den.aspects.shell = {
    homeManager = {config, ...}: {
      home = {
        sessionVariables = {
          EDITOR = "nvim";
          MANPAGER = "bat -plman";
          TODO_DIR = "${config.home.homeDirectory}/notes";
        };

        shellAliases = {
          ls = "eza";
          la = "ls -la";
          bat = "cat";
          lg = "lazygit";
          c = "cargo";
          du = "dust";
          g = "git";
          gs = "git status";
          ga = "git add";
          gaa = "git add --all";
          gc = "git commit";
          gcm = "git commit -m";
          gca = "git commit --amend";
          gcl = "git clone";
          gsw = "git switch";
          gp = "git push";
          gpl = "git pull";
          gl = "git log --oneline --graph --decorate --all";
          gld = "git log --pretty=format:\"%C(yellow)%h%C(reset) - %an [%C(green)%ar%C(reset)] %s\"";
          v = "nvim";
          notes = "cd ~/notes && nvim";
        };
      };

      programs = {
        fish = {
          enable = true;

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

            zellij_layouts = {
              body = ''
                tv zellij
              '';
            };
          };
        };

        carapace = {
          enable = true;
          enableFishIntegration = true;
        };

        devenv = {
          enable = true;
          enableBashIntegration = true;
          enableFishIntegration = true;
        };

        direnv = {
          enable = true;
          nix-direnv.enable = true;
          enableBashIntegration = true;
          enableFishIntegration = true;
        };

        eza = {
          enable = true;
          enableFishIntegration = true;
        };

        fzf = {
          enable = true;
          enableFishIntegration = true;
        };

        lazygit = {
          enable = true;
          enableFishIntegration = true;
        };

        starship = {
          enable = true;
          enableFishIntegration = true;
        };

        television = {
          enable = true;
          enableFishIntegration = true;
        };

        yazi = {
          enable = true;
          enableFishIntegration = true;
        };

        zellij = {
          enable = true;
          enableFishIntegration = true;
        };

        zoxide = {
          enable = true;
          enableFishIntegration = true;
        };
      };
    };
  };
}
