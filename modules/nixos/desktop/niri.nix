{ flake, ... }:
{
  imports = [ flake.nixosModules.desktop.default ];
}
