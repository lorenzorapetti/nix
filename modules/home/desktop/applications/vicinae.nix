{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.services.vicinae;
  style = config.stylix;
in {
  config = {
    services.vicinae = mkIf cfg.enable {
      systemd = {
        enable = true;
        autoStart = true;
        environment = {
          USE_LAYER_SHELL = 1;
        };
      };

      settings = {
        close_on_focus_loss = false;
        favicon_service = "twenty";
        font = {
          normal = {
            size = style.fonts.sizes.applications;
            normal = style.fonts.sansSerif.name;
          };
        };
        theme = {
          light = {
            name = "catppuccin-latte";
            iconTheme = "default";
          };
          dark = {
            name = "catppuccin-mocha";
            iconTheme = "Catppuccin Mocha Dark";
          };
        };
        search_files_in_root = false;
        pop_to_root_on_close = true;
        launcher_window = {
          csd = true;
          opacity = 0.9;
          rounding = 10;
        };
      };
    };
  };
}
