{
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf mkMerge mkDefault;

  cfg = config.services.kanata;
in {
  config = {
    services.kanata = mkMerge [
      {enable = mkDefault true;}
      (mkIf cfg.enable {
        keyboards.builtin = {
          devices = cfg.devices;
          port = 6666;

          extraDefCfg = ''
            process-unmapped-keys yes
          '';

          config = ''
            (defsrc
              esc
              caps
            )

            (defvar
              tap-time 150
              hold-time 210
            )

            (deflayer default
              caps
              @caps
            )

            (defalias
              caps (tap-hold $tap-time $hold-time esc lctl)
            )
          '';
        };
      })
    ];
  };

  options = {
    services.kanata.devices = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "List of input devices to manage with Kanata.";
    };
  };
}
