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
    ffmpeg

    perSystem.self.screenshot
    perSystem.self.screenrecord
  ];

  services.mako.enable = lib.mkDefault true;
  services.udiskie = {
    enable = true;
    automount = true;
    notify = true;
  };

  services.batsignal = {
    enable = lib.mkDefault true;
  };
}
