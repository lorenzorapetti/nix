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
        # Terminal emulators
        alacritty
        kitty
        wezterm
        ghostty

        imv
        mpv

        # Browsers
        firefox
        inputs'.helium.packages.default
      ];

      programs.obs-studio.enable = true;
      programs.thunderbird.enable = true;
    };
  };
}
