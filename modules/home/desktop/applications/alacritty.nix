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
      theme = "catppuccin_mocha";

      settings = {
        option_as_alt = mkIf stdenv.isDarwin "Both";

        font.normal.family = "GeistMono Nerd Font";
        font.size = 12;

        mouse.hide_when_typing = true;
      };
    };
  };
}
