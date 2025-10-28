{lib, ...}: let
  inherit (lib) mkDefault;
in {
  imports = [./alacritty.nix ./zed.nix];

  programs.alacritty.enable = mkDefault true;
  programs.zed-editor.enable = mkDefault true;
}
