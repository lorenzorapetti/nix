{
  den.aspects.base-applications = {
    homeManager = {
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
                family = "GeistMono Nerd Font Mono";
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

          clearDefaultKeybinds = true;
          settings = {
            language = "en";
            font-family = "GeistMono Nerd Font Mono";
            font-size = 11;
            cursor-style = "block";
            mouse-hide-while-typing = true;
            scrollbar = "never";
          };
        };
      };
    };
  };
}
