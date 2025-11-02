{
  osConfig,
  config,
  lib,
  perSystem,
  ...
}: let
  inherit (lib) mkIf;

  cfg = osConfig.services.awww;
  awww = perSystem.awww.awww;
in {
  config = mkIf cfg.enable {
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
  };
}
