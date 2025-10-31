{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (pkgs) stdenv;

  cfg = config.programs.alacritty;
in {
  config = {
    programs.alacritty = mkIf cfg.enable {
      settings = {
        option_as_alt = mkIf stdenv.isDarwin "Both";

        mouse.hide_when_typing = true;
      };
    };
  };
}
