{lib, ...}: let
  inherit (lib) mkDefault;
in {
  imports = [./nix.nix ./nixpkgs.nix ./programs.nix];

  virtualisation.docker = {
    enable = mkDefault true;
    enableOnBoot = mkDefault false;
  };
}
