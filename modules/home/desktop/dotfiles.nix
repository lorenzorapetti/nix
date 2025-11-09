{
  flake,
  lib,
  config,
  ...
}: let
  inherit (lib) mergeAttrsList;

  link = flake.lib.link config;

  confFiles = link.linkConfFiles [
    "mpv/fonts/fluent-system-icons.ttf"
    "mpv/fonts/material-design-icons.ttf"
    "mpv/scripts/modernz.lua"
  ];

  confDirs = link.linkConfDirs [
    "waybar"
    "zed"
  ];

  links = mergeAttrsList (confDirs ++ confFiles);
in {
  xdg.configFile = links;
}
