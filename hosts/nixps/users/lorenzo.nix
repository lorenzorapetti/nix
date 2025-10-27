{ config, flake, ... }:
{
  imports = [
    flake.homeModules.default
    flake.homeModules.desktop.niri
    flake.homeModules.users.lorenzo
  ];
}
