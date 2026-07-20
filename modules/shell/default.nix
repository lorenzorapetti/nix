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
          cat = "bat";
          lg = "lazygit";
          c = "cargo";
          du = "dust";
          j = "just";
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

          settings = {
            add_newline = true;
            format = "$directory$git_branch$git_status$git_state$line_break$character";

            character = {
              error_symbol = "[](bold red)";
              success_symbol = "[](bold green)";
              vimcmd_replace_one_symbol = "[](bold purple)";
              vimcmd_replace_symbol = "[](bold purple)";
              vimcmd_symbol = "[](bold green)";
              vimcmd_visual_symbol = "[](bold yellow)";
            };

            git_branch = {
              format = "[$symbol$branch(:$remote_branch)]($style) ";
            };
          };
        };

        television = {
          enable = true;
          enableFishIntegration = true;

          channels = {
            zellij = {
              metadata = {
                name = "zellij";
                description = "List zellij sessions, layouts, and zoxide paths";
                requirements = ["zellij" "zoxide"];
              };
              source = {
                command = "zellij-sesh";
                no_sort = true;
              };
              preview = {
                command = "zellij-sesh preview '{}'";
              };
              keybindings = {
                enter = "actions:open";
              };
              actions.open = {
                description = "Open entry: switch if inside zellij, else attach/launch (session, layout, or zoxide path)";
                mode = "execute";
                command = "zellij-sesh open {}";
              };
            };
          };
        };

        nix-search-tv = {
          enable = true;
          enableTelevisionIntegration = true;
        };

        yazi = {
          enable = true;
          enableFishIntegration = true;
        };
      };
    };
  };
}
