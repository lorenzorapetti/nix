{
  perSystem = {pkgs, ...}: {
    packages.system-action = pkgs.writeShellApplication {
      name = "system-action";
      runtimeInputs = [pkgs.gawk];
      text = ''
        # system-action: route desktop actions through noctalia (v5) when it is
        # running, otherwise fall back to a compositor/tool-native command.
        #
        # noctalia is detected with `pgrep -f noctalia`. When noctalia is not running
        # and the "other" command is N/A, the action is a silent no-op (exit 0).
        #
        # | system-action command                     | noctalia                                                       | other                                                           |
        # |-------------------------------------------|----------------------------------------------------------------|-----------------------------------------------------------------|
        # | system-action volume up                   | noctalia msg volume-up 5%                                       | wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+                       |
        # | system-action volume down                 | noctalia msg volume-down 5%                                     | wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-                       |
        # | system-action volume mute                 | noctalia msg volume-mute                                        | wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle                      |
        # | system-action mic mute                    | noctalia msg mic-mute                                           | wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle                    |
        # | system-action brightness up               | noctalia msg brightness-up 5%                                   | brightnessctl -e4 -n2 set 5%+                                   |
        # | system-action brightness down             | noctalia msg brightness-down 5%                                 | brightnessctl -e4 -n2 set 5%-                                   |
        # | system-action brightness set <number>     | noctalia msg brightness-set <number>                            | brightnessctl set -s <number>                                   |
        # | system-action brightness restore          | N/A                                                             | brightnessctl -r                                                |
        # | system-action kbd-backlight on            | N/A                                                            | brightnessctl -sd "<device>" set "100%"                         |
        # | system-action kbd-backlight off           | N/A                                                            | brightnessctl -sd "<device>" set 0                              |
        # | system-action kbd-backlight restore       | N/A                                                            | brightnessctl -rd "<device>"                                    |
        # | system-action idle toggle                 | noctalia msg caffeine-toggle                                    | N/A                                                             |
        # | system-action window-switcher             | noctalia msg window-switcher                                    | N/A                                                             |
        # | system-action dpms on                     | noctalia msg dpms-on                                            | hyprctl dispatch 'hl.dsp.dpms({ action = "enable" })'           |
        # | system-action dpms off                    | noctalia msg dpms-off                                           | hyprctl dispatch 'hl.dsp.dpms({ action = "disable" })'          |
        # | system-action panel-toggle settings       | noctalia msg settings-toggle                                    | N/A                                                             |
        # | system-action panel-toggle wallpaper      | noctalia msg panel-toggle wallpaper                             | N/A                                                             |
        # | system-action panel-toggle control-center | noctalia msg panel-toggle control-center                       | N/A                                                             |
        # | system-action wallpaper random            | noctalia msg wallpaper-random                                   | awww-switch (Note: Check if awww daemon is running)             |
        # | system-action wallpaper set <path>        | noctalia msg wallpaper-set <path>                              | awww img -t wave <path> (Note: Check if awww daemon is running) |
        # | system-action session menu-toggle         | noctalia msg panel-toggle session                              | wleave                                                          |
        # | system-action session lock                | noctalia msg session lock                                       | pidof hyprlock || hyprlock                                      |
        # | system-action session suspend             | noctalia msg session lock-and-suspend                          | systemctl suspend                                               |
        # | system-action session reboot              | noctalia msg session reboot                                     | hyprshutdown -t 'Restarting...' --post-cmd 'reboot'            |
        # | system-action session shutdown            | noctalia msg session shutdown                                   | hyprshutdown -t 'Shutting down...' --post-cmd 'shutdown -P 0'  |
        # | system-action notifications clear-active  | noctalia msg notification-clear-active                         | dunstctl close-all                                              |
        # | system-action notifications clear-history | noctalia msg notification-clear-history                        | N/A                                                             |
        # | system-action notifications show-history  | noctalia msg panel-open control-center notifications           | dunst-history-menu                                              |
        # | system-action notifications toggle-dnd    | noctalia msg notification-dnd-toggle                          | N/A                                                             |
        # | system-action media previous              | noctalia msg media previous                                    | playerctl previous                                              |
        # | system-action media toggle                | noctalia msg media toggle                                       | playerctl play-pause                                            |
        # | system-action media stop                  | noctalia msg media stop                                         | playerctl stop                                                  |
        # | system-action media next                  | noctalia msg media next                                         | playerctl next                                                  |
        # | system-action screenshot region           | noctalia msg screenshot-region                                 | screenshot region                                               |
        # | system-action screenshot fullscreen       | noctalia msg screenshot-fullscreen                            | screenshot fullscreen                                           |
        # | system-action screenrecord start          | noctalia msg plugin noctalia/screen_recorder:service all start | screenrecord                                                    |
        # | system-action screenrecord stop           | noctalia msg plugin noctalia/screen_recorder:service all stop  | screenrecord --stop-recording                                   |

        SUBCOMMAND="''${1-}"
        ACTION="''${2-}"
        ARG="''${3-}"

        noctalia_running() {
          pgrep -f noctalia >/dev/null 2>&1
        }

        usage() {
          cat >&2 <<'EOF'
        Usage: system-action <subcommand> <action> [args]

        Subcommands:
          volume        up | down | mute
          mic           mute
          brightness    up | down | set <number> | restore
          kbd-backlight on | off | restore
          idle          toggle
          window-switcher
          dpms          on | off
          panel-toggle  settings | wallpaper | control-center
          wallpaper     random | set <path>
          session       menu-toggle | lock | suspend | reboot | shutdown
          notifications clear-active | clear-history | show-history | toggle-dnd
          media         previous | toggle | stop | next
          screenshot    region | fullscreen
          screenrecord  start | stop
        EOF
          exit 1
        }

        volume() {
          case "''${ACTION}" in
          up)
            if noctalia_running; then noctalia msg volume-up 5%; else wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+; fi ;;
          down)
            if noctalia_running; then noctalia msg volume-down 5%; else wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-; fi ;;
          mute)
            if noctalia_running; then noctalia msg volume-mute; else wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle; fi ;;
          *)
            echo "Usage: system-action volume <up|down|mute>" >&2; exit 1 ;;
          esac
        }

        mic() {
          case "''${ACTION}" in
          mute)
            if noctalia_running; then noctalia msg mic-mute; else wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle; fi ;;
          *)
            echo "Usage: system-action mic <mute>" >&2; exit 1 ;;
          esac
        }

        brightness_available() {
          # brightnessctl is usable only when present AND a backlight device exists
          # (e.g. laptop panel, or an external monitor via ddcci-backlight).
          command -v brightnessctl >/dev/null 2>&1 \
            && [[ -n "$(brightnessctl -l -c backlight -m 2>/dev/null)" ]]
        }

        brightness() {
          # When noctalia is running it handles brightness itself and brightnessctl
          # is not needed; otherwise fall back to brightnessctl if available, and
          # silently no-op if it isn't (e.g. no backlight device).
          case "''${ACTION}" in
          up)
            if noctalia_running; then
              noctalia msg brightness-up 5%
            elif brightness_available; then
              brightnessctl -e4 -n2 set 5%+
            fi ;;
          down)
            if noctalia_running; then
              noctalia msg brightness-down 5%
            elif brightness_available; then
              brightnessctl -e4 -n2 set 5%-
            fi ;;
          set)
            if [[ -z "''${ARG}" ]]; then
              echo "Usage: system-action brightness set <number>" >&2; exit 1
            fi
            if noctalia_running; then
              noctalia msg brightness-set "''${ARG}"
            elif brightness_available; then
              brightnessctl set -s "''${ARG}"
            fi ;;
          restore)
            if noctalia_running; then
              :
            elif brightness_available; then
              brightnessctl -r
            fi ;;
          *)
            echo "Usage: system-action brightness <up|down|set <number>|restore>" >&2; exit 1 ;;
          esac
        }

        kbd_backlight() {
          # Find the keyboard backlight LED device (e.g. asus::kbd_backlight); if none
          # exists (or brightnessctl is missing) the subcommand is a silent no-op.
          local device
          if ! command -v brightnessctl >/dev/null 2>&1; then
            return
          fi
          device="$(brightnessctl -lm 2>/dev/null | awk -F, '/kbd_backlight/ { print $1; exit }')"
          if [[ -z "''${device}" ]]; then
            return
          fi
          case "''${ACTION}" in
          on)
            brightnessctl -sd "''${device}" set "100%" ;;
          off)
            brightnessctl -sd "''${device}" set 0 ;;
          restore)
            brightnessctl -rd "''${device}" ;;
          *)
            echo "Usage: system-action kbd-backlight <on|off|restore>" >&2; exit 1 ;;
          esac
        }

        idle() {
          case "''${ACTION}" in
          toggle)
            if noctalia_running; then noctalia msg caffeine-toggle; fi ;;
          *)
            echo "Usage: system-action idle <toggle>" >&2; exit 1 ;;
          esac
        }

        window_switcher() {
          if noctalia_running; then noctalia msg window-switcher; fi
        }

        dpms() {
          case "''${ACTION}" in
          on)
            if noctalia_running; then noctalia msg dpms-on; else hyprctl dispatch 'hl.dsp.dpms({ action = "enable" })'; fi ;;
          off)
            if noctalia_running; then noctalia msg dpms-off; else hyprctl dispatch 'hl.dsp.dpms({ action = "disable" })'; fi ;;
          *)
            echo "Usage: system-action dpms <on|off>" >&2; exit 1 ;;
          esac
        }

        panel_toggle() {
          case "''${ACTION}" in
          settings)
            if noctalia_running; then noctalia msg settings-toggle; fi ;;
          wallpaper)
            if noctalia_running; then noctalia msg panel-toggle wallpaper; fi ;;
          control-center)
            if noctalia_running; then noctalia msg panel-toggle control-center; fi ;;
          *)
            echo "Usage: system-action panel-toggle <settings|wallpaper|control-center>" >&2; exit 1 ;;
          esac
        }

        wallpaper() {
          case "''${ACTION}" in
          random)
            if noctalia_running; then noctalia msg wallpaper-random; else awww-switch; fi ;;
          set)
            if [[ -z "''${ARG}" ]]; then
              echo "Usage: system-action wallpaper set <path>" >&2; exit 1
            fi
            if noctalia_running; then noctalia msg wallpaper-set "''${ARG}"; else awww img -t wave "''${ARG}"; fi ;;
          *)
            echo "Usage: system-action wallpaper <random|set <path>>" >&2; exit 1 ;;
          esac
        }

        session() {
          case "''${ACTION}" in
          menu-toggle)
            if noctalia_running; then noctalia msg panel-toggle session; else wleave; fi ;;
          lock)
            if noctalia_running; then noctalia msg session lock; else pidof hyprlock || hyprlock; fi ;;
          suspend)
            if noctalia_running; then noctalia msg session lock-and-suspend; else systemctl suspend; fi ;;
          reboot)
            if noctalia_running; then noctalia msg session reboot; else hyprshutdown -t 'Restarting...' --post-cmd 'reboot'; fi ;;
          shutdown)
            if noctalia_running; then noctalia msg session shutdown; else hyprshutdown -t 'Shutting down...' --post-cmd 'shutdown -P 0'; fi ;;
          *)
            echo "Usage: system-action session <menu-toggle|lock|suspend|reboot|shutdown>" >&2; exit 1 ;;
          esac
        }

        notifications() {
          case "''${ACTION}" in
          clear-active)
            if noctalia_running; then noctalia msg notification-clear-active; else dunstctl close-all; fi ;;
          clear-history)
            if noctalia_running; then noctalia msg notification-clear-history; fi ;;
          show-history)
            if noctalia_running; then noctalia msg panel-open control-center notifications; else dunst-history-menu; fi ;;
          toggle-dnd)
            if noctalia_running; then noctalia msg notification-dnd-toggle; fi ;;
          *)
            echo "Usage: system-action notifications <clear-active|clear-history|show-history|toggle-dnd>" >&2; exit 1 ;;
          esac
        }

        media() {
          case "''${ACTION}" in
          previous)
            if noctalia_running; then noctalia msg media previous; else playerctl previous; fi ;;
          toggle)
            if noctalia_running; then noctalia msg media toggle; else playerctl play-pause; fi ;;
          stop)
            if noctalia_running; then noctalia msg media stop; else playerctl stop; fi ;;
          next)
            if noctalia_running; then noctalia msg media next; else playerctl next; fi ;;
          *)
            echo "Usage: system-action media <previous|toggle|stop|next>" >&2; exit 1 ;;
          esac
        }

        screenshot_action() {
          case "''${ACTION}" in
          region)
            if noctalia_running; then noctalia msg screenshot-region; else screenshot region; fi ;;
          fullscreen)
            if noctalia_running; then noctalia msg screenshot-fullscreen; else screenshot fullscreen; fi ;;
          *)
            echo "Usage: system-action screenshot <region|fullscreen>" >&2; exit 1 ;;
          esac
        }

        screenrecord_action() {
          case "''${ACTION}" in
          start)
            if noctalia_running; then noctalia msg plugin noctalia/screen_recorder:service all start; else screenrecord; fi ;;
          stop)
            if noctalia_running; then noctalia msg plugin noctalia/screen_recorder:service all stop; else screenrecord --stop-recording; fi ;;
          *)
            echo "Usage: system-action screenrecord <start|stop>" >&2; exit 1 ;;
          esac
        }

        case "''${SUBCOMMAND}" in
        volume) volume ;;
        mic) mic ;;
        brightness) brightness ;;
        kbd-backlight) kbd_backlight ;;
        idle) idle ;;
        window-switcher) window_switcher ;;
        dpms) dpms ;;
        panel-toggle) panel_toggle ;;
        wallpaper) wallpaper ;;
        session) session ;;
        notifications) notifications ;;
        media) media ;;
        screenshot) screenshot_action ;;
        screenrecord) screenrecord_action ;;
        *) usage ;;
        esac
      '';
    };
  };
}
