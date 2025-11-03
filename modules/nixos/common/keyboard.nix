{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  interceptionEnabled = config.services.caps2esc.enable;

  intercept = "${pkgs.interception-tools}/bin/intercept";
  caps2esc = "${pkgs.interception-tools-plugins.caps2esc}/bin/caps2esc";
  uinput = "${pkgs.interception-tools}/bin/uinput";
  udevmon = "${pkgs.interception-tools}/bin/udevmon";

  configFile = pkgs.writeText "udevmon.yaml" ''
    - JOB: ${intercept} -g /dev/input/event0 | ${caps2esc} -m 1 | ${uinput} -d /dev/input/event0
      DEVICE:
        EVENTS:
          EV_KEY: [KEY_CAPSLOCK, KEY_ESC]
  '';
in {
  config = mkIf interceptionEnabled {
    environment.systemPackages = with pkgs; [
      interception-tools
      interception-tools-plugins.caps2esc
    ];

    systemd.services.udevmon = {
      description = "Monitor input devices for launching tasks";
      wants = ["systemd-udev-settle.service"];
      after = ["systemd-udev-settle.service"];
      documentation = ["man:udev(7)"];

      path = [
        pkgs.bash
      ];

      serviceConfig = {
        ExecStart = "${udevmon} -c ${configFile}";
        Nice = -20;
        Restart = "on-failure";
        OOMScoreAdjust = -1000;
      };

      wantedBy = ["multi-user.target"];
    };
  };
}
