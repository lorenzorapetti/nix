{
  lib,
  config,
  pkgs,
  ...
}: {
  services.flatpak = {
    enable = lib.mkDefault true;
    packages = [
      "com.bambulab.BambuStudio"
    ];
  };

  systemd.services.flatpak-repo = lib.mkIf config.services.flatpak.enable {
    wantedBy = ["multi-user.target"];
    path = [pkgs.flatpak];
    script = ''
      flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    '';
  };

  environment.systemPackages = lib.mkIf config.services.flatpak.enable [
    pkgs.flatpak
    pkgs.gnome-software
  ];
}
