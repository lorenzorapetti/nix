{lib, ...}: let
  inherit (lib) mkDefault;
in {
  virtualisation.docker = {
    enable = mkDefault true;
    enableOnBoot = mkDefault false;
  };
}
