{config, ...}: let
  colors = config.lib.stylix.colors;
in {
  programs.imv = {
    enable = true;
    settings = {
      options = {
        background = colors.base01;
      };

      aliases.x = "close";
      binds = {
        "y" = "exec wl-copy \"$imv_current_file\"";
        "<Ctrl+y>" = "exec wl-copy < \"$imv_current_file\"";
      };
    };
  };
}
