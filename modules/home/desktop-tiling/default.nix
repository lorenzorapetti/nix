{flake, ...}: {
  imports = [flake.homeModules.desktop ./programs.nix ./hyprlock.nix ./mako.nix ./swayosd.nix ./satty.nix];
}
