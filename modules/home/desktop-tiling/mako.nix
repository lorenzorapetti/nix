{
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.services.mako;
in {
  config = mkIf cfg.enable {
    services.mako.settings = {
      anchor = "top-right";
      default-timeout = 5000;
      width = 420;
      outer-margin = 20;
      padding = "10,15";
      border-size = 2;
      border-radius = 8;
      max-icon-size = 32;
      max-history = 10;
    };
  };
}
