{
  den.default.nixos = {
    config,
    lib,
    pkgs,
    ...
  }: {
    options.defaultTerminal = {
      quickTerminalAppId = lib.mkOption {
        type = lib.types.str;
        default = "quick-terminal";
        description = ''
          app-id/class given to quick-terminal windows. Must stay matched by the
          `quick-terminal` window rule in modules/desktop/hyprland/config/rules.lua.
          ghostty requires a GTK application ID here (e.g. com.ghostty.quick_terminal).
        '';
      };

      quickTerminal = lib.mkOption {
        type = lib.types.package;
        readOnly = true;
        description = "Wrapper launching `package` as a floating quick terminal running the given command.";
        default = pkgs.writeShellApplication {
          name = "quick-terminal";
          text = ''
            exec ${lib.getExe config.defaultTerminal.package} \
              ${config.defaultTerminal.appIdFlag}=${config.defaultTerminal.quickTerminalAppId} \
              ${config.defaultTerminal.execFlag} "$@"
          '';
        };
      };
    };
  };

  den.aspects.desktop.base-applications.homeManager = {osConfig, ...}: {
    home.packages = [osConfig.defaultTerminal.quickTerminal];
  };
}
