{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./flatpak.nix
    ./1password.nix
    ./steam.nix
    # ./bambu-studio.nix
  ];

  environment.systemPackages = with pkgs; [
    nautilus
    file-roller

    imv
    mpv
  ];

  programs.obs-studio.enable = lib.mkDefault true;
  programs.thunderbird.enable = lib.mkDefault true;
}
