{lib, ...}: let
  inherit (lib) mkDefault mkEnableOption;
in {
  imports = [
    ./cache.nix
    ./nix.nix
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
  };

  options = {
    services.caps2esc.enable = mkEnableOption "Enable Caps Lock to esc/ctrl";
  };
}
