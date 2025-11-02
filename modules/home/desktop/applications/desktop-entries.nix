{
  lib,
  pkgs,
  osConfig,
  flake,
  ...
}: let
  inherit (lib) mkIf;
  inherit (builtins) elem;

  installedPkgs = osConfig.environment.systemPackages;
  pkgInstalled = pkg: mkIf (elem pkg installedPkgs);

  imvInstalled = pkgInstalled pkgs.imv;
  mpvInstalled = pkgInstalled pkgs.mpv;

  mimeTypes = flake.lib.mimeTypes;
in {
  xdg.desktopEntries = {
    imv = imvInstalled {
      name = "Image Viewer";
      exec = "imv %F";
      icon = "${flake}/icons/imv.png";
      type = "Application";
      mimeType = mimeTypes.image;
      terminal = false;
      categories = ["Graphics" "Viewer"];
    };

    mpv = mpvInstalled {
      name = "Media Player";
      genericName = "Multimedia Player";
      exec = "mpv --player-operation-mode=pseudo-gui -- %U";
      type = "Application";
      icon = "mpv";
      terminal = false;
      categories = ["AudioVideo" "Audio" "Video" "Player" "TV"];
      mimeType = mimeTypes.video;
    };
  };

  xdg.mimeApps = {
    enable = true;
  };
}
