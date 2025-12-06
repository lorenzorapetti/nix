{
  pkgs,
  lib,
  ...
}: {
  imports = [./1password.nix ./steam.nix];

  environment.systemPackages = with pkgs; [
    nautilus

    imv
    mpv
  ];

  programs.obs-studio.enable = lib.mkDefault true;
}
