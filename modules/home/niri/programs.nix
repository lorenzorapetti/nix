{pkgs, ...}: {
  home.packages = with pkgs; [
    xwayland-satellite-unstable
  ];
}
