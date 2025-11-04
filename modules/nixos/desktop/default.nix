{lib, ...}: let
  inherit (lib) mkEnableOption;
in {
  imports = [
    ./stylix.nix
    ./bluetooth.nix
    ./sound.nix
    ./fonts.nix
    ./sddm.nix
    ./services
    ./applications
  ];

  options = {
    services.swayosd.enable = mkEnableOption "Enable SwayOSD";
    services.awww.enable = mkEnableOption "Enable awww";
    programs.obsidian.enable = mkEnableOption "Enable Obsidian";
    programs.vesktop.enable = mkEnableOption "Enable Vesktop (Discord Client)";
  };
}
