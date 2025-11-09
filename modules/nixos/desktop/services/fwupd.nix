{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.services.fwupd;
in {
  config = mkIf cfg.enable {
    systemd.timers.fwupdmgr = {
      wantedBy = ["timers.target"];
      timerConfig = {
        OnCalendar = "daily";
        Persistent = true;
        Unit = "fwupdmgr.service";
      };
    };

    systemd.services.fwupdmgr = let
      fwupd = "${pkgs.fwupd}/bin/fwupdmgr";
      notify-send = "${pkgs.libnotify}/bin/notify-send";
      jq = "${pkgs.jq}/bin/jq";
      sudo = "${pkgs.sudo}/bin/sudo";
      who = "${pkgs.coreutils}/bin/who";
      awk = "${pkgs.gawk}/bin/awk";
      id = "${pkgs.coreutils}/bin/id";
    in {
      script = ''
        set -eu

        ${fwupd} refresh --json

        updates=$(${fwupd} get-updates --json | ${jq} -r '.Devices | length')

        if [ "$updates" -gt 0 ]; then
            # Notify all logged-in users
            for user in $(${who} | ${awk} '{print $1}' | sort -u); do
                ${sudo} -u "$user" DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$(${id} -u "$user")/bus \
                ${notify-send} "Firmware Updates Available" "There are $updates firmware updates available."
            done
        fi
      '';
      serviceConfig = {
        Type = "oneshot";
        User = "root";
      };
    };
  };
}
