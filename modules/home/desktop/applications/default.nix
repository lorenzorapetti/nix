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
    ./alacritty.nix
    ./browsers.nix
    ./zen-browser.nix
    ./zed.nix
  ];

  home.packages = with pkgs; [
    ticktick
  ];

  programs.alacritty.enable = mkDefault true;
  programs.zed-editor.enable = mkDefault true;
  programs.firefox.enable = mkDefault true;
  programs.chromium.enable = mkDefault true;
  programs.zen-browser.enable = mkDefault true;

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    extraConfig = ''
      Host *
         	IdentityAgent ~/.1password/agent.sock
    '';
  };
}
