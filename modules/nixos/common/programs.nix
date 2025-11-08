{
  pkgs,
  flake,
  lib,
  ...
}: let
  inherit (lib) mkDefault;
in {
  imports = [
    flake.commonModules.packages
  ];

  environment.systemPackages = with pkgs; [
    btop
    gnumake
    inetutils
    nmap
    tailscale
    usbutils

    # Nix
    home-manager
    cachix
  ];

  services.tailscale.enable = mkDefault true;
  programs.nix-ld.enable = mkDefault true;
}
