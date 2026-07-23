{den, ...}: {
  # Applications that are agnostic to the desktop environment, but are necessary.
  den.aspects.desktop.wm-applications = {
    includes = [
      den.aspects.desktop.vicinae
    ];

    nixos = {pkgs, ...}: {
      environment.systemPackages = with pkgs; [
        nautilus
        file-roller
      ];
    };

    homeManager = {
      config,
      osConfig,
      ...
    }: {
      xdg.configFile."gtk-3.0/bookmarks".text = ''
        file:///home/${config.home.username}/Desktop Desktop
        file:///home/${config.home.username}/Documents Documents
        file:///home/${config.home.username}/Downloads Downloads
        file:///home/${config.home.username}/Pictures Pictures
        file:///home/${config.home.username}/Videos Videos
        file:///home/${config.home.username}/code Code
        file:///home/${config.home.username}/Nextcloud Nextcloud
      '';

      programs = {
        satty = {
          enable = true;
          settings = {
            general = {
              fullscreen = false;
              early-exit = true;
              corner-roundness = 12;
              initial-tool = "brush";
              copy-command = "wl-copy";
              annotation-size-factor = 2;
              output-filename = "~/Pictures/Screenshots/screenshot-%Y-%m-%d_%H:%M:%S.png";
              save-after-copy = true;
              default-hide-toolbars = false;
              primary-highlighter = "block";
              disable-notifications = true;
              actions-on-right-click = [];
              actions-on-enter = ["save-to-clipboard"];
              actions-on-escape = ["exit"];
              no-window-decoration = true;
              brush-smooth-history-size = 10;
            };

            font = {
              family = osConfig.fonts.sans;
              style = "Bold";
            };

            color-palette = {
              palette = [
                "#00ffff"
                "#a52a2a"
                "#dc143c"
                "#ff1493"
                "#ffd700"
                "#008000"
              ];
              custom = [
                "#00ffff"
                "#a52a2a"
                "#dc143c"
                "#ff1493"
                "#ffd700"
                "#008000"
              ];
            };
          };
        };
      };
    };
  };
}
