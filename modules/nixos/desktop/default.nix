{lib, ...}: {
  imports = [
    ./stylix.nix
    ./bluetooth.nix
    ./sound.nix
    ./fonts.nix
    ./swayosd.nix
    ./applications
  ];

  options = {
    services.swayosd.enable = lib.mkEnableOption "Enable SwayOSD";
  };
}
