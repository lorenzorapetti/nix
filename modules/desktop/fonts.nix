{
  den.aspects.desktop = {
    nixos = {
      pkgs,
      config,
      ...
    }: {
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
          serif = [config.fonts.serif] ++ config.fonts.fallbackSerif;
          sansSerif = [config.fonts.sans] ++ config.fonts.fallbackSans;
          monospace = [config.fonts.mono] ++ config.fonts.fallbackMono;
        };
      };
    };
  };
}
