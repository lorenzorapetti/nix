{
  lib,
  config,
  pkgs,
  ...
}: {
  services.flatpak = {
    enable = lib.mkDefault true;
    remotes = [
      {
        name = "flathub";
        location = "https://flathub.org/repo/flathub.flatpakrepo";
      }
      {
        name = "flathub-beta";
        location = "https://flathub.org/beta-repo/flathub-beta.flatpakrepo";
      }
    ];
    packages = [
      "com.bambulab.BambuStudio"
    ];
  };

  environment.systemPackages = lib.mkIf config.services.flatpak.enable [
    pkgs.flatpak
    pkgs.gnome-software
  ];
}
