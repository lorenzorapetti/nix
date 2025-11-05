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

    features.v4l2loopback.enable = mkDefault true;
  };

  options = {
    features.v4l2loopback.enable = mkEnableOption "Enable v4l2loopback";
  };
}
