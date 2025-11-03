{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.services.displayManager.sddm;
in {
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      sddm-astronaut
      kdePackages.qtmultimedia
    ];

    services.displayManager.sddm = {
      theme = "sddm-astronaut-theme";

      package = pkgs.kdePackages.sddm;
      extraPackages = with pkgs; [sddm-astronaut kdePackages.qtmultimedia];

      wayland = {
        enable = true;
      };
      settings = {
        Wayland = {
          EnableHiDPI = true;
        };
      };
    };
  };
}
