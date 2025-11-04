{lib, ...}: {
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
    services.swayosd.enable = lib.mkEnableOption "Enable SwayOSD";
    services.awww.enable = lib.mkEnableOption "Enable awww";
    programs.obsidian.enable = lib.mkEnableOption "Enable Obsidian";
  };
}
