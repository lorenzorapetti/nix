{ flake, ... }:
{
  imports = [
    flake.homeModules.common
    flake.homeModules.niri
    flake.homeModules.lorenzo
  ];
}
