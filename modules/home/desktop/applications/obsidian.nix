{
  osConfig,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  cfg = osConfig.programs.obsidian;
in {
  config = mkIf cfg.enable {
    programs.obsidian = {
      enable = true;

      vaults.home = {
        enable = true;
        target = "Obsidian/Home";
      };
    };
  };
}
