{
  lib,
  flake,
  ...
}: let
  inherit (lib) map mergeAttrsList;
  inherit (builtins) listToAttrs;

  associations = value: mimes:
    listToAttrs (map (name: {
        inherit name value;
      })
      mimes);
in {
  xdg.mimeApps = let
    browser = associations ["brave-browser.desktop"] flake.lib.mimeTypes.web;

    images = associations ["imv.desktop"] [
      "image/png"
      "image/jpeg"
      "image/gif"
      "image/webp"
      "image/bmp"
      "image/tiff"
    ];

    videos = associations ["mpv.desktop"] [
      "video/mp4"
      "video/x-msvideo"
      "video/x-matroska"
      "video/x-flv"
      "video/x-ms-wmv"
      "video/mpeg"
      "video/ogg"
      "video/webm"
      "video/quicktime"
      "video/3gpp"
      "video/3gpp2"
      "video/x-ms-asf"
      "video/x-ogm+ogg"
      "video/x-theora+ogg"
      "application/ogg"
    ];

    added = mergeAttrsList [browser images videos];
    default = mergeAttrsList [browser images videos];
  in {
    associations.added = added;
    defaultApplications = default;
  };
}
