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
    ./imv.nix
    ./mpv.nix
    ./desktop-entries.nix
    ./mimeapps.nix
    ./obs.nix
    ./obsidian.nix
    ./webapps.nix
  ];

  home.packages = with pkgs; [
    ticktick
    telegram-desktop
    pinta
    localsend
  ];

  services.vicinae.enable = mkDefault true;

  programs.alacritty.enable = mkDefault true;
  programs.zed-editor.enable = mkDefault true;
  programs.firefox.enable = mkDefault true;
  programs.chromium.enable = mkDefault true;
  programs.zen-browser.enable = mkDefault true;
  programs.vesktop.enable = mkDefault true;
  programs.wezterm.enable = mkDefault true;
}
