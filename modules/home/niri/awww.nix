{
  config,
  lib,
  perSystem,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkDefault mkMerge;

  cfg = config.services.awww;
  awww = perSystem.awww.awww;
in {
  config = mkMerge [
    {services.awww.enable = mkDefault true;}
    (mkIf cfg.enable {
      home.packages = [
        awww
      ];

      systemd.user.services.awww = {
        Install = {
          WantedBy = [config.wayland.systemd.target];
        };

        Unit = {
          ConditionEnvironment = "WAYLAND_DISPLAY";
          Description = "awww-daemon";
          After = [config.wayland.systemd.target];
          PartOf = [config.wayland.systemd.target];
        };

        Service = {
          ExecStart = "${awww}/bin/awww-daemon";
          Restart = "always";
          RestartSec = 10;
        };
      };
    })
  ];

  options = {
    services.awww.enable = mkEnableOption "Enable AWWW daemon for wallpapers.";
  };
}
