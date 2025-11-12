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

  nixpkgs.overlays = [
    flake.inputs.rust-overlay.overlays.default
  ];

  environment.systemPackages = with pkgs; [
    btop
    gnumake
    inetutils
    nmap
    tailscale
    usbutils
    lm_sensors

    # Nix
    home-manager
    cachix
    devenv

    # Common languages
    nodejs_24
    bun
    deno
    rust-bin.stable.latest.default
  ];

  services.tailscale.enable = mkDefault true;
  programs.nix-ld.enable = mkDefault true;
}
