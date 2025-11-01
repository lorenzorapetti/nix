{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.services.vicinae;
in {
  config = {
    services.vicinae = mkIf cfg.enable {
      autoStart = true;
    };
  };
}
