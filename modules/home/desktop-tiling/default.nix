{flake, ...}: {
  imports = [
    flake.homeModules.desktop
    ./programs.nix
    ./services.nix
    ./hyprlock.nix
    ./mako.nix
    ./swayosd.nix
  ];
}
