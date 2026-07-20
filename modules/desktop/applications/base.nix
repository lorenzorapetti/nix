{den, ...}: {
  # Absolutely necessary apps for every machine
  den.aspects.desktop.base-applications = {
    includes = with den.aspects; [
      desktop._1password
    ];

    nixos = {
      pkgs,
      inputs',
      ...
    }: {
      environment.systemPackages = with pkgs; [
        # Browsers
        firefox
        inputs'.helium.packages.default

        ticktick
      ];

      programs.obs-studio.enable = true;
      programs.thunderbird.enable = true;
    };

    homeManager = {
      programs = {
        imv = {
          enable = true;
          settings = {
            aliases = {
              x = "close";
            };

            binds = {
              "<Ctrl+y>" = "exec wl-copy < \"$imv_current_file\"";
              y = "exec wl-copy \"$imv_current_file\"";
            };
          };
        };

        mpv = {
          enable = true;
        };
      };
    };
  };
}
