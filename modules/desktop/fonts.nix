{
  den.aspects.desktop = {
    nixos = {pkgs, ...}: {
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
          serif = ["Noto Serif" "Noto Serif CJK JP"];
          sansSerif = ["Noto Sans" "Noto Sans CJK JP"];
          monospace = ["GeistMono Nerd Font Mono" "Noto Sans Mono" "Noto Sans Mono CJK J"];
        };
      };
    };
  };
}
