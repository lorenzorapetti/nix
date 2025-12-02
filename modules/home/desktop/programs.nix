{pkgs, ...}: {
  home.packages = with pkgs; [
    libnotify
    wl-clipboard
    wayland-utils
    wev
    libinput

    cliphist
    playerctl
    brightnessctl

    gemini-cli-bin
  ];
}
