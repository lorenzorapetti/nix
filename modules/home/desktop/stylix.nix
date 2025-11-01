{
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf;

  makoEnabled = config.services.mako.enable;
in {
  stylix.targets = {
    alacritty.enable = true;
    lazygit.enable = true;
    mako.enable = mkIf makoEnabled true;
  };
}
