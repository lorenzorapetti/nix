{
  flake,
  config,
  osConfig,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  niriEnabled = osConfig.programs.niri.enable;
in {
  imports = [
    flake.homeModules.common
    flake.inputs.niri.homeModules.config
    flake.homeModules.niri
    flake.homeModules.lorenzo
  ];

  config.programs.niri.settings = mkIf niriEnabled {
    outputs = {
      "eDP-1" = {
        backdrop-color = config.lib.stylix.colors.base01;
        background-color = config.lib.stylix.colors.base01;

        mode = {
          width = 2560;
          height = 1600;
          refresh = 120.0;
        };

        position = {
          x = 0;
          y = 0;
        };

        scale = 1.3;
      };
    };
  };
}
