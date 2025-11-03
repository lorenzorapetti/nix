{pkgs, ...}: let
  config = pkgs.writeText "udevmon.yaml" ''
    - JOB: intercept -g $DEVNODE | caps2esc | uinput -d $DEVNODE
      DEVICE:
        EVENTS:
          EV_KEY: [KEY_CAPSLOCK, KEY_ESC]
  '';
in {
  environment.systemPackages = with pkgs; [
    interception-tools
    interception-tools-plugins.caps2esc
  ];

  systemd.services.udevmon = {
    description = "Monitor input devices for launching tasks";
    wants = ["systemd-udev-settle.service"];
    after = ["systemd-udev-settle.service"];
    documentation = ["man:udev(7)"];

    serviceConfig = {
      ExecStart = "${pkgs.interception-tools}/bin/udevmon -c ${config}";
      Nice = -20;
      Restart = "on-failure";
      OOMScoreAdjust = -1000;
    };

    wantedBy = ["multi-user.target"];
  };
}
