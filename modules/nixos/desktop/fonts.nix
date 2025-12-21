{
  pkgs,
  config,
  ...
}: let
  fonts = config.stylix.fonts;
in {
  fonts = {
    packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      nerd-fonts.geist-mono

      liberation_ttf
      eb-garamond
      fira-sans
      montserrat
      noto-fonts
      open-sans
      roboto
      source-sans-pro
      noto-fonts-cjk-sans

      noto-fonts-color-emoji
      openmoji-black
      openmoji-color
      twemoji-color-font
      twitter-color-emoji
    ];

    fontconfig.defaultFonts = {
      sansSerif = [fonts.sansSerif.name "Noto Sans CJK JP"];
      serif = [fonts.sansSerif.name "Noto Sans CJK JP"];
      monospace = [fonts.monospace.name "Noto Sans Mono CJK JP"];
    };
  };
}
