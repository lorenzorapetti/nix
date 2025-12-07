{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkDefault mkEnableOption mkMerge mkIf;

  cfg = config.features.v4l2loopback;
in {
  config = mkMerge [
    {
      features.v4l2loopback.enable = mkDefault false;
    }
    (mkIf cfg.enable {
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
    })
  ];

  options = {
    features.v4l2loopback.enable = mkEnableOption "Enable v4l2loopback";
  };
}
