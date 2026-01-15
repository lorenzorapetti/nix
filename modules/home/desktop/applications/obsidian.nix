{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkMerge mkDefault;

  cfg = config.programs.obsidian;
in {
  programs.obsidian = mkMerge [
    {enable = mkDefault false;}
    (mkIf cfg.enable {
      vaults.home = {
        enable = true;
        target = "Obsidian/Home";
      };
    })
  ];
}
