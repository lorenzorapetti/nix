{flake, ...}: {
  imports = [flake.homeModules.desktop ./hyprlock.nix];
}
