{
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf mkMerge mkDefault;

  cfg = config.services.kanata;
in {
  services.kanata = mkMerge [
    {enable = mkDefault true;}
    (mkIf cfg.enable {
      keyboards.builtin = {
        devices = [
          "/dev/input/by-path/platform-i8042-serio-0-event-kbd"
        ];
        port = 6666;

        extraDefCfg = ''
          process-unmapped-keys yes
        '';

        config = ''
          (defsrc
            esc
            caps
            spc
          )

          (defvar
            tap-time 150
            hold-time 210
          )

          (deflayer default
            caps
            @caps
            @space
          )

          (defalias
            caps (tap-hold $tap-time $hold-time esc lctl)
            space (tap-hold-press $tap-time $hold-time spc (multi lctl lalt lmet lsft))
          )
        '';
      };
    })
  ];
}
