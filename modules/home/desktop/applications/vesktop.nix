{
  osConfig,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  cfg = osConfig.programs.vesktop;
in {
  config = mkIf cfg.enable {
    programs.vesktop = {
      enable = true;
    };
  };
}
