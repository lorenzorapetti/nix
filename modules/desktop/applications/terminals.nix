{
  den.default.nixos = {
    lib,
    pkgs,
    ...
  }: {
    options.defaultTerminal = {
      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.foot;
        description = "Terminal emulator this host launches by default.";
      };

      desktopFile = lib.mkOption {
        type = lib.types.str;
        default = "foot.desktop";
        description = "Desktop file ID of `package`, for xdg-terminal-exec.";
      };

      appIdFlag = lib.mkOption {
        type = lib.types.str;
        default = "--app-id";
        description = ''
          Flag `package` uses to override a window's app-id/class.
          `--class` for ghostty, alacritty and kitty.
        '';
      };

      execFlag = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = ''
          Flag separating `package`'s own arguments from the command to run.
          `-e` for ghostty and alacritty, empty for foot and kitty.
        '';
      };
    };
  };

  den.aspects.desktop.base-applications = {
    nixos = {config, ...}: {
      xdg.terminal-exec = {
        enable = true;
        settings.default = [config.defaultTerminal.desktopFile];
      };
    };

    homeManager = {
      lib,
      osConfig,
      ...
    }: {
      home.sessionVariables.TERMINAL = lib.getExe osConfig.defaultTerminal.package;

      programs = {
        alacritty = {
          enable = true;

          settings = {
            window = {
              decorations = "None";
              option_as_alt = "OnlyLeft";
            };

            font = {
              normal = {
                family = osConfig.fonts.mono;
                style = "Regular";
              };
            };
          };
        };

        ghostty = {
          enable = true;
          enableBashIntegration = true;
          enableFishIntegration = true;

          systemd.enable = false;

          settings = {
            language = "en";
            font-family = osConfig.fonts.mono;
            font-size = 11;
            cursor-style = "block";
            mouse-hide-while-typing = true;
            scrollbar = "never";
            quit-after-last-window-closed = false;
          };
        };

        foot = {
          enable = true;

          settings = {
            main = {
              font = "${osConfig.fonts.mono}:size=11";
            };
            scrollback.lines = 10000;
            mouse.hide-when-typing = "yes";
          };
        };
      };
    };
  };
}
