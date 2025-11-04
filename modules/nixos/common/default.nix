{lib, ...}: let
  inherit (lib) mkDefault mkEnableOption;
in {
  imports = [
    ./cache.nix
    ./nix.nix
    ./kernel.nix
    ./nixpkgs.nix
    ./programs.nix
    ./keyboard.nix
  ];

  config = {
    virtualisation.docker = {
      enable = mkDefault true;
      enableOnBoot = mkDefault false;
    };

    services.caps2esc.enable = mkDefault true;
    features.v4l2loopback.enable = mkDefault true;
  };

  options = {
    services.caps2esc.enable = mkEnableOption "Enable Caps Lock to esc/ctrl";
    features.v4l2loopback.enable = mkEnableOption "Enable v4l2loopback";
  };
}
