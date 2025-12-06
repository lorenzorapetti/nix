{
  pkgs,
  lib,
  ...
}: {
  programs.fish.enable = lib.mkDefault true;
  users.defaultUserShell = pkgs.fish;
}
