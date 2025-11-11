{
  lib,
  flake,
  ...
}: let
  inherit (lib) mkDefault mkEnableOption;
in {
  imports = [
    flake.inputs.sops-nix.nixosModules.sops
    ./sops.nix
    ./cache.nix
    ./nix.nix
    ./kernel.nix
    ./nixpkgs.nix
    ./programs.nix
    ./keyboard.nix
    ./protonvpn.nix
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
