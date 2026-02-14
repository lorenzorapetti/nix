{
  flake,
  lib,
  ...
}: {
  imports = [
    flake.homeModules.desktop
    ./programs.nix
    ./dms.nix
    ../desktop-tiling/programs.nix
    ../desktop-tiling/services.nix
    # ./hypridle.nix
    ./niri.nix
    # ./waybar.nix
    # ./awww.nix
  ];

  services.mako.enable = lib.mkForce false;
  services.batsignal.enable = lib.mkForce false;

  home.sessionVariables = {
    QT_QPA_PLATFORM = "wayland";
  };
}
