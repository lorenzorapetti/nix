{
  pkgs,
  lib,
  config,
  flake,
  ...
}: {
  imports = [flake.inputs.stylix.nixosModules.stylix];

  config.stylix = {
    enable = true;
    autoEnable = false;

    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
    polarity = "dark";

    image = pkgs.fetchurl {
      url = "https://github.com/zhichaoh/catppuccin-wallpapers/blob/main/landscapes/shaded_landscape.png?raw=true";
      hash = lib.fakeHash;
    };

    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.geist-mono;
        name = "GeistMono Nerd Font";
      };

      sansSerif = {
        package = pkgs.noto-fonts;
        name = "Noto Sans";
      };

      serif = config.stylix.fonts.sansSerif;

      emoji = {
        package = pkgs.noto-fonts-color-emoji;
        name = "Noto Color Emoji";
      };

      sizes = {
        applications = 10;
      };
    };

    cursor = {
      package = pkgs.catppuccin-cursors.mochaDark;
      name = "catppuccin-mocha-dark-cursors";
      size = 24;
    };
  };
}
