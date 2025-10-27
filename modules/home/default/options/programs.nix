{ flake, lib, ... }:
let
  inherit (lib) map mergeAttrsList;

  confFiles = [ ];

  confDirs = map flake.lib.link.linkDir [
    "helix"
  ];

  links = mergeAttrsList (confDirs ++ confFiles);
in
{
  xdg.configFile = links;
}
