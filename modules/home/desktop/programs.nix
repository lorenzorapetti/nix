{pkgs, ...}: {
  home.packages = with pkgs; [
    libnotify
    wl-clipboard
    wayland-utils
    libinput

    cliphist
    playerctl
    brightnessctl
  ];
}
