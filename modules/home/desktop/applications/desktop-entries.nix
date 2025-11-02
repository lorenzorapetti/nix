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
in {
  xdg.desktopEntries = {
    imv = imvInstalled {
      name = "Image Viewer";
      exec = "imv %F";
      icon = "${flake}/icons/imv.png";
      type = "Application";
      mimeType = [
        "image/png"
        "image/jpeg"
        "image/jpg"
        "image/gif"
        "image/bmp"
        "image/webp"
        "image/tiff"
        "image/x-xcf"
        "image/x-portable-pixmap"
        "image/x-xbitmap"
      ];
      terminal = false;
      categories = ["Graphics" "Viewer"];
    };
  };

  xdg.mimeApps = {
    enable = true;
  };
}
