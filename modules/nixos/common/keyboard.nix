{
  pkgs,
  config,
  lib,
  perSystem,
  ...
}: let
  inherit (lib) mkIf mkOption mkEnableOption types concatMapStringsSep;

  interception = config.services.keyboard-interception;

  intercept = "${pkgs.interception-tools}/bin/intercept";
  caps2esc = "${pkgs.interception-tools-plugins.caps2esc}/bin/caps2esc";
  ralt2hypr = "${perSystem.self.ralt2hyper}/bin/ralt2hyper";
  uinput = "${pkgs.interception-tools}/bin/uinput";
  udevmon = "${pkgs.interception-tools}/bin/udevmon";

  mkJob = device: ''
    - JOB: ${intercept} -g ${device} | ${caps2esc} -m 1 | ${ralt2hypr} | ${uinput} -d ${device}
      DEVICE:
        LINK: ${device}
        EVENTS:
          EV_KEY: [KEY_CAPSLOCK, KEY_ESC, KEY_RIGHTALT]
  '';

  configFile =
    pkgs.writeText "udevmon.yaml"
    (concatMapStringsSep "\n" mkJob interception.devices);
in {
  config = mkIf interception.enable {
    environment.systemPackages = with pkgs; [
      interception-tools
      interception-tools-plugins.caps2esc
      perSystem.self.ralt2hyper
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

    services.udev.extraRules = ''
      KERNEL=="event*", SUBSYSTEM=="input", ATTRS{name}=="NuPhy Gem80-2 Keyboard", SYMLINK+="input/gem-80-kbd"
    '';
  };

  options = {
    services.keyboard-interception = mkOption {
      type = types.submodule {
        options = {
          enable = mkEnableOption "Enable interception-tools";
          devices = mkOption {
            type = types.listOf types.str;
          };
        };
      };
    };
  };
}
