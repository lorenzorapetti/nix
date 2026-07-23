{
  den.aspects.desktop.base-applications = {
    homeManager = {osConfig, ...}: {
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

          systemd.enable = true;

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
      };
    };
  };
}
