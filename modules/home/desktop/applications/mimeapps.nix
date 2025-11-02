{
  lib,
  osConfig,
  pkgs,
  ...
}: let
  inherit (lib) mkIf map mergeAttrsList;
  inherit (builtins) elem listToAttrs;

  installedPkgs = osConfig.environment.systemPackages;
  pkgInstalled = pkg: mkIf (elem pkg installedPkgs);

  imvInstalled = pkgInstalled pkgs.imv;

  associations = value: mimes:
    listToAttrs (map (name: {
        inherit name value;
      })
      mimes);
in {
  xdg.mimeApps = let
    browser = associations ["brave-browser.desktop"] [
      "application/x-extension-shtml"
      "application/x-extension-xhtml"
      "application/x-extension-html"
      "application/x-extension-xht"
      "application/x-extension-htm"
      "x-scheme-handler/unknown"
      "x-scheme-handler/mailto"
      "x-scheme-handler/chrome"
      "x-scheme-handler/about"
      "x-scheme-handler/https"
      "x-scheme-handler/http"
      "application/xhtml+xml"
      "application/json"
      "text/plain"
      "text/html"
    ];

    images = associations ["imv.desktop"] [
      "image/png"
      "image/jpeg"
      "image/gif"
      "image/webp"
      "image/bmp"
      "image/tiff"
    ];

    added = mergeAttrsList [browser images];
    default = mergeAttrsList [browser images];
  in {
    associations.added = added;
    defaultApplications = default;
  };
}
