{
  pkgs,
  lib,
  perSystem,
  ...
}: {
  home.packages = with pkgs; [
    networkmanagerapplet
    udisks2
    udiskie

    # Screenshot utilities
    grim
    slurp
    wayfreeze
    perSystem.self.screenshot
  ];

  services.mako.enable = lib.mkDefault true;
  services.udiskie = {
    enable = true;
    automount = true;
    notify = true;
  };
}
