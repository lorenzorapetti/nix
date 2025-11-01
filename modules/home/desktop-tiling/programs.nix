{
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    networkmanagerapplet
    udisks2
    udiskie
  ];

  services.mako.enable = lib.mkDefault true;
  services.udiskie = {
    enable = true;
    automount = true;
    notify = true;
  };
}
