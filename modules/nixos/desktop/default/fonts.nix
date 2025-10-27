{ pkgs, ... }: {
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.geist-mono

    eb-garamond
    fira-sans
    montserrat
    noto-fonts
    open-sans
    roboto
    source-sans-pro

    noto-fonts-emoji
    openmoji-black
    openmoji-color
    twemoji-color-font
    twitter-color-emoji
  ];
}
