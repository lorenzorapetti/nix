{
  lib,
  inputs,
  pkgs,
  ...
}: let
  inherit (lib) mkDefault;
in {
  imports = [
    inputs.zen-browser.homeModules.twilight
    ./vicinae.nix
    ./alacritty.nix
    ./browsers.nix
    ./zen-browser.nix
    ./zed.nix
  ];

  home.packages = with pkgs; [
    ticktick
  ];

  services.vicinae.enable = mkDefault true;

  programs.alacritty.enable = mkDefault true;
  programs.zed-editor.enable = mkDefault true;
  programs.firefox.enable = mkDefault true;
  programs.chromium.enable = mkDefault true;
  programs.zen-browser.enable = mkDefault true;
}
