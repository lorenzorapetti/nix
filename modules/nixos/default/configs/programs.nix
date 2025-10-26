{ pkgs, flake, ... }:
{
  imports = [
    flake.modules.global.packages
  ];

  environment.systemPackages = with pkgs; [
    btop
    gnumake
    inetutils
    nmap
    home-manager
  ];
}
