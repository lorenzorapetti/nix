{
  lib,
  config,
  ...
}: let
  cfg = config.programs.waybar;

  configSource = "\"\${XDG_CONFIG_HOME}/waybar/config-niri.jsonc\"";
  styleSource = "\"\${XDG_CONFIG_HOME}/waybar/style-niri.css\"";
in {
  programs.waybar = {
    enable = lib.mkForce true;
    systemd = {
      enable = true;
    };
  };

  systemd.user.services.waybar.Service.ExecStart = lib.mkForce "${cfg.package}/bin/waybar${lib.optionalString cfg.systemd.enableDebug " -l debug"} -c ${configSource} -s ${styleSource}";
}
