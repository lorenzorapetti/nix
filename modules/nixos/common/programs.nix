{
  pkgs,
  flake,
  ...
}: {
  imports = [
    flake.commonModules.packages
  ];

  environment.systemPackages = with pkgs; [
    btop
    gnumake
    inetutils
    nmap
    home-manager
  ];
}
