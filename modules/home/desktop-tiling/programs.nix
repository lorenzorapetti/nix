{
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    networkmanagerapplet
  ];

  services.mako.enable = lib.mkDefault true;
}
