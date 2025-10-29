{ lib, ... }:
let
  inherit (lib) mkDefault;
in
{
  imports = [
    ./alacritty.nix
    ./browsers.nix
    ./zed.nix
  ];

  programs.alacritty.enable = mkDefault true;
  programs.zed-editor.enable = mkDefault true;
  programs.firefox.enable = mkDefault true;
  programs.chromium.enable = mkDefault true;
}
