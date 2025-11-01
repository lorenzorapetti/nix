{pkgs, ...}: {
  home.packages = with pkgs; [
    wl-clipboard
    wayland-utils
    libinput

    cliphist
    playerctl
    brightnessctl
  ];
}
