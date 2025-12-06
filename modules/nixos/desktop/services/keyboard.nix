{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkMerge mkDefault;

  kanataCfg = config.services.kanata;
  qmkCfg = config.services.qmk;
in {
  config = {
    services.kanata = mkMerge [
      {enable = mkDefault true;}
      (mkIf kanataCfg.enable {
        keyboards.builtin = {
          devices = kanataCfg.devices;
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

    services.qmk.enable = mkDefault true;

    services.udev = mkIf qmkCfg.enable {
      packages = with pkgs; [
        qmk
        qmk-udev-rules # the only relevant
        qmk_hid
        vial
      ]; # packages
    }; # udev

    environment.systemPackages = mkIf qmkCfg.enable [
      pkgs.qmk
      pkgs.vial
    ];
  };

  options = {
    services.kanata.devices = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "List of input devices to manage with Kanata.";
    };

    services.qmk.enable = lib.mkEnableOption "Enable QMK.";
  };
}
