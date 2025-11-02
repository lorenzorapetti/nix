{
  lib,
  config,
  osConfig,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;

  enabled = osConfig.services.swayosd.enable;

  colors = config.lib.stylix.colors.withHashtag;
  style = pkgs.writeText "swayosd-style.css" ''
    window#osd {
      background: ${colors.base01};
    }
  '';
in {
  config = mkIf enabled {
    services.swayosd = {
      enable = true;
      stylePath = style;
    };
  };
}
