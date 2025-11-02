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
      autoStart = true;

      settings = {
        closeOnFocusLoss = false;
        faviconService = "twenty";
        font = {
          size = style.fonts.sizes.applications;
          normal = style.fonts.sansSerif.name;
        };
        theme = {
          name = "catppuccin-mocha";
          iconTheme = "Catppuccin Mocha Dark";
        };
        rootSearch.searchFiles = false;
        popToRootOnClose = true;
        window = {
          csd = true;
          opacity = 0.9;
          rounding = 10;
        };
      };
    };
  };
}
