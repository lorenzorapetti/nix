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
            end =
              [
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

          calendar.enabled = true;

          desktop_widgets.enabled = true;

          idle = {
            pre_action_fade_seconds = 0;
            behavior_order = [
              "Reduce Brightness"
              "Keyboard Brightness"
              "lock"
              "screen-off"
              "lock-and-suspend"
            ];

            behavior = {
              "Keyboard Brightness" = {
                action = "command";
                command = "system-action kbd-backlight off";
                resume_command = "system-action kbd-backlight restore";
                enabled = true;
                timeout = 180;
              };

              "Reduce Brightness" = {
                action = "command";
                command = "system-action brightness set 10%";
                resume_command = "system-action brightness restore";
                enabled = true;
                timeout = 180;
              };

              lock = {
                action = "lock";
                enabled = true;
                timeout = 300;
              };

              lock-and-suspend = {
                action = "lock_and_suspend";
                enabled = true;
                timeout = 600;
              };

              screen-off = {
                action = "screen_off";
                enabled = true;
                timeout = 400;
              };
            };
          };

          location.address = "Latina, Italia";

          lockscreen = {
            blurred_desktop = true;
            fingerprint = false;
          };

          lockscreen_widgets = {
            enabled = false;
            schema_version = 2;
          };

          osd.kinds = {
            bluetooth = false;
            keyboard_layout = false;
            media = false;
            wifi = false;
          };

          dock = {
            enabled = false;
            auto_hide = true;
            icon_size = 36;
            reserve_space = false;
          };

          plugins.enabled = ["noctalia/screen_recorder"];

          plugin_settings."noctalia/screen_recorder" = {
            color_range = "full";
            copy_to_clipboard = true;
          };

          shell = {
            avatar_path = "~/profile.png";
            clipboard_enabled = false;
            font_family = osConfig.fonts.nerd;
            launch_apps_as_systemd_services = true;
            polkit_agent = true;
            settings_show_advanced = true;
            shadow.alpha = 0.2;

            panel = {
              session_placement = "centered";
              wallpaper_placement = "floating";
            };

            screenshot = {
              copy_to_clipboard = false;
              directory = "~/Pictures/Screenshots";
              pipe_command = "satty -f -";
              pipe_to_command = true;
              save_to_file = false;
            };

            session.actions = [
              {
                action = "lock";
                enabled = true;
                shortcut = "l";
                variant = "default";
              }
              {
                action = "logout";
                enabled = true;
                shortcut = "x";
                variant = "default";
              }
              {
                action = "lock_and_suspend";
                enabled = true;
                shortcut = "u";
                variant = "default";
              }
              {
                action = "reboot";
                enabled = true;
                shortcut = "r";
                variant = "default";
              }
              {
                action = "shutdown";
                enabled = true;
                shortcut = "s";
                variant = "destructive";
              }
            ];
          };

          wallpaper = {
            directory = "~/Pictures/Wallpapers";
            automation = {
              enabled = true;
              interval_seconds = 36000;
            };
          };

          widget = {
            active_window = {
              max_length = 180;
              title_scroll = "on_hover";
            };

            battery.display_mode = "graphic";
            clock.format = "%a %e %b %H:%M";
            cpu.show_label = false;

            media = {
              hide_when_no_media = true;
              max_length = 180;
              title_scroll = "on_hover";
            };

            network.show_label = false;
            network_rx.show_label = false;
            network_tx.show_label = false;
            privacy.hide_inactive = true;

            ram = {
              show_label = false;
              stat = "ram_pct";
            };

            recorder.type = "noctalia/screen_recorder:recorder";

            taskbar = {
              empty_color = "primary";
              focused_color = "tertiary";
              group_by_workspace = true;
              group_single_icon_per_app = true;
              occupied_color = "primary";
              show_active_indicator = false;
              workspace_label_placement = "inside";
            };

            tray = {
              drawer = true;
              match_adjacent_spacing = true;
            };

            weather.show_condition = false;

            workspaces = {
              active_pill_size = 2.0;
              display = "name";
              empty_color = "primary";
              focused_color = "tertiary";
              hide_when_empty = true;
              occupied_color = "primary";
            };
          };
        };
      };
    };
  };
}
