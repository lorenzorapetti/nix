{lib, ...}: {
  imports = [
    ./stylix.nix
    ./bluetooth.nix
    ./sound.nix
    ./fonts.nix
    ./services
    ./applications
  ];

  options = {
    services.swayosd.enable = lib.mkEnableOption "Enable SwayOSD";
    services.awww.enable = lib.mkEnableOption "Enable awww";
  };
}
