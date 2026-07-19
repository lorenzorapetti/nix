{
  inputs,
  den,
  lib,
  ...
}: {
  den.aspects.desktop.noctalia = {
    includes = with den.aspects; [
      desktop.noctalia-greeter
    ];

    nixos = {
      imports = [
        inputs.noctalia.nixosModules.default
      ];

      programs.noctalia = {
        enable = true;
      };
    };

    homeManager = {osConfig, ...}: {
      imports = [
        inputs.noctalia.homeModules.default
      ];

      programs.noctalia = {
        enable = true;
        systemd.enable = true;

        settings = {
          bar.default = {
            background_opacity = 0.85;
            capsule_group = [];
            center = ["taskbar"];
            end = [
              "network_rx"
              "network_tx"
              "cpu"
              "ram"
              "network"
            ]
              ++ lib.optional osConfig.hardware.bluetooth.enable "bluetooth"
              ++ [
                "notifications"
                "screenshot"
                "recorder"
                "wallpaper"
                "caffeine"
                "volume"
              ]
              ++ lib.optional osConfig.services.power-profiles-daemon.enable "battery"
              ++ [
                "control-center"
                "session"
              ];
            margin_edge = 0;
            margin_ends = 0;
            radius = 0;
            start = [
              "clock"
              "weather"
              "tray"
              "active_window"
              "privacy"
            ];
            thickness = 40;
            widget_spacing = 14;
          };

          shell = {
            polkit_agent = true;
          };
        };
      };
    };
  };
}
