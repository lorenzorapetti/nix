{flake, ...}: {
  imports = [flake.homeModules.desktop ./programs.nix ./niri.nix];
}
