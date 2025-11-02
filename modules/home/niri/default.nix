{flake, ...}: {
  imports = [
    flake.homeModules.desktop-tiling
    ./programs.nix
    ./hypridle.nix
    ./niri.nix
    ./waybar.nix
    ./awww.nix
  ];
}
