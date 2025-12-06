{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkMerge mkDefault;

  cfg = config.services.swayosd;
in {
  config = mkMerge [
    {services.swayosd.enable = mkDefault true;}
    (mkIf cfg.enable {
      services.dbus.packages = [pkgs.swayosd];

      systemd.services.swayosd-input = {
        enable = true;
        description = "SwayOSD LibInput backend for listening to certain keys like CapsLock, ScrollLock, VolumeUp, etc...";
        after = ["graphical.target"];

        unitConfig = {
          ConditionPathExists = "${pkgs.swayosd}/bin/swayosd-libinput-backend";
          PartOf = ["graphical.target"];
        };

        serviceConfig = {
          User = "root";
          Type = "dbus";
          BusName = "org.erikreider.swayosd";
          ExecStart = "${pkgs.swayosd}/bin/swayosd-libinput-backend";
          Restart = "on-failure";
        };

        wantedBy = ["graphical.target"];
      };

      environment.etc."xdg/swayosd/backend.toml" = {
        enable = true;
        text = ''
          [input]
          ignore_caps_lock_key = true
        '';
      };
    })
  ];

  options = {
    services.swayosd.enable = mkEnableOption "Enable SwayOSD";
  };
}
