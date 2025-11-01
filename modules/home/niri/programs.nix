{pkgs, ...}: {
  home.packages = with pkgs; [
    xwayland-satellite-unstable
    gnome-keyring
    libsecret

    xdg-desktop-portal
    xdg-desktop-portal-gtk
    xdg-desktop-portal-gnome

    # gnome-keyring gui
    seahorse
  ];
}
