{
  den,
  lib,
  ...
}: {
  den.aspects.desktop.noctalia = {
    includes = with den.aspects; [
      desktop.noctalia-greeter
    ];

    homeManager = {
      pkgs,
      osConfig,
      ...
    }: let
      brightnessctl = lib.getExe pkgs.brightnessctl;
    in {
      programs.noctalia = {
        enable = true;
        systemd.enable = true;

        settings = {
          bar.default = {
            background_opacity = 0.85;
            capsule_group = [];
            center = ["workspaces"];
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
                "recorder"
                "caffeine"
                "volume"
              ]
              ++ lib.optional osConfig.services.power-profiles-daemon.enable "battery";
            margin_edge = 0;
            margin_ends = 0;
            radius = 0;
            shadow = false;
            start = [
              "home_assistant"
              "clock"
              "weather"
              "tray"
              "taskbar"
              "privacy"
            ];
            thickness = 40;
            widget_spacing = 14;
          };

          calendar = {
            enabled = true;

            account.nebulab = {
              name = "Nebulab";
              type = "google";
            };

            reminders.all_day_digest_time = "";
          };

          control_center = {
            width = 900;
            shortcuts = [
              {type = "wallpaper";}
              {type = "caffeine";}
              {type = "notification";}
              {type = "power_profile";}
              {type = "wifi";}
              {type = "bluetooth";}
            ];
          };

          desktop_widgets.enabled = false;

          hooks.session_locked = "1password --lock";

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
                command = "${brightnessctl} -sd '*::kbd_backlight' set 0";
                resume_command = "${brightnessctl} -rd '*::kbd_backlight'";
                enabled = true;
                timeout = 180;
              };

              "Reduce Brightness" = {
                action = "command";
                command = "${brightnessctl} -s set 10%";
                resume_command = "${brightnessctl} -r";
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
            allow_empty_password = true;
            blurred_desktop = true;
            fingerprint = lib.mkDefault false;
            transition = [];
          };

          lockscreen_widgets = {
            enabled = lib.mkDefault false;
            schema_version = 2;
          };

          notification = {
            history_retention_hours = 6;
            max_visible = 5;
          };

          osd = {
            border = false;
            kinds = {
              bluetooth = false;
              keyboard_layout = false;
              media = false;
              wifi = false;
            };
          };

          dock = {
            enabled = false;
            auto_hide = true;
            icon_size = 36;
            reserve_space = false;
          };

          plugins.enabled = [
            "noctalia/screen_recorder"
            "davemhammer/tailscale"
            "pozzoo/hassio"
          ];

          plugin_settings = {
            "davemhammer/tailscale" = {
              manager_open_near_click = false;
              manager_placement = "attached";
              notify_on_peer_change = false;
            };

            "noctalia/screen_recorder" = {
              audio_codec = "aac";
              color_range = "full";
              copy_to_clipboard = true;
              video_source = "focused";
            };

            # ha_token is intentionally not managed here (secret).
            "pozzoo/hassio" = {
              entity_manager_placement = "attached";
              ha_url = "https://ha.francescorapetti.dev";
              shortcut_entity_1 = "switch.camera_sonoff_1000cba156";
              shortcut_entity_2 = "switch.stampante_3d";
            };
          };

          shell = {
            avatar_path = "~/profile.png";
            button_borders = false;
            card_borders = false;
            clipboard_enabled = false;
            external_ip_enabled = true;
            input_borders = false;
            popup_borders = false;
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
              annotate = true;
              copy_to_clipboard = false;
              directory = "~/Pictures/Screenshots";
              filename_pattern = "%Y-%m-%d-%H%M";
              pipe_command = "satty -f -";
              pipe_to_command = false;
              save_to_file = true;
              skip_annotate_on_copy_save = true;
            };

            window_switcher.current_workspace_only = true;

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

          system.monitor.disk_poll_seconds = 0;

          wallpaper = {
            directory = "~/Pictures/Wallpapers";
            automation = {
              enabled = false;
              interval_seconds = 36000;
              recursive = true;
            };
          };

          weather.effects = false;

          widget = {
            notifications.hide_when_no_unread = true;

            active_window = {
              max_length = 180;
              title_scroll = "on_hover";
            };

            bar.type = "noctalia/world_clock:bar";
            battery.display_mode = "graphic";
            clock.format = "%a %e %b %H:%M";
            cpu = {
              show_label = false;
              show_value = false;
            };

            home_assistant = {
              glyph = "smart-home";
              type = "custom_button";

              actions.left = "panel-toggle pozzoo/hassio:entity_manager";
            };

            media = {
              hide_when_no_media = true;
              max_length = 180;
              title_scroll = "on_hover";
            };

            network.show_label = false;
            network_rx = {
              show_label = false;
              show_value = false;
            };

            network_tx = {
              show_label = false;
              show_value = false;
            };

            privacy.hide_inactive = true;

            ram = {
              show_label = false;
              show_value = false;
              stat = "ram_pct";
            };

            recorder.type = "noctalia/screen_recorder:recorder";

            tailscale = {
              glyph = "brand-openvpn";
              type = "custom_button";

              actions.left = "panel-toggle davemhammer/tailscale:manager";
            };

            taskbar = {
              empty_color = "primary";
              focused_color = "tertiary";
              group_by_workspace = true;
              group_single_icon_per_app = true;
              occupied_color = "primary";
              only_active_workspace = true;
              show_active_indicator = true;
              show_workspace_label = false;
              workspace_group_capsule = false;
              workspace_label_placement = "inside";
            };

            tray = {
              drawer = true;
              match_adjacent_spacing = true;
            };

            weather.show_condition = false;

            workspaces = {
              active_pill_size = 1.8;
              empty_color = "primary";
              focused_color = "tertiary";
              occupied_color = "primary";
            };
          };
        };
      };
    };
  };
}
