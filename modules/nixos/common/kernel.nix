{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.features.v4l2loopback;
in {
  config = mkIf cfg.enable {
    environment.systemPackages = [
      config.boot.kernelPackages.v4l2loopback
      pkgs.v4l-utils
    ];

    boot = {
      extraModulePackages = [
        config.boot.kernelPackages.v4l2loopback
      ];
      kernelModules = ["v4l2loopback"];
      extraModprobeConfig = ''
        options v4l2loopback devices=2 video_nr=1,2 card_label="OBS Cam, Virt Cam" exclusive_caps=1
      '';
    };
  };
}
