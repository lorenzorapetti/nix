{pkgs, ...}: {
  imports = [./1password.nix];

  environment.systemPackages = with pkgs; [
    nautilus

    imv
    mpv
  ];
}
