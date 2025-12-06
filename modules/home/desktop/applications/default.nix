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
    ./wezterm.nix
    ./browsers.nix
    ./zen-browser.nix
    ./imv.nix
    ./mpv.nix
    ./desktop-entries.nix
    ./mimeapps.nix
    ./obs.nix
    ./obsidian.nix
    ./vesktop.nix
    ./webapps.nix
  ];

  home.packages = with pkgs; [
    ticktick
    telegram-desktop
    pinta
    localsend
    bambu-studio
  ];

  services.vicinae.enable = mkDefault true;

  programs.alacritty.enable = mkDefault true;
  programs.zed-editor.enable = mkDefault true;
  programs.firefox.enable = mkDefault true;
  programs.chromium.enable = mkDefault true;
  programs.zen-browser.enable = mkDefault true;
}
