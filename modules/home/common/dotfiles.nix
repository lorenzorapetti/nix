{
  flake,
  lib,
  config,
  ...
}: let
  inherit (lib) mergeAttrsList;

  link = flake.lib.link config;

  confFiles = [];

  confDirs = link.linkConfDirs [
    "helix"
    "waybar"
  ];

  links = mergeAttrsList (confDirs ++ confFiles);
in {
  xdg.configFile = links;
}
