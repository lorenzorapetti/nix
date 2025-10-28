{ lib, ... }: let
  inherit (lib) mkDefault;
in {
  imports = [ ./zed.nix ];

  programs.zed-editor.enable = mkDefault true;
}
