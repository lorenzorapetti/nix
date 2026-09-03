{
  den.aspects.desktop.wlr-which-key = {
    homeManager = {
      pkgs,
      osConfig,
      ...
    }: {
      home.packages = with pkgs; [
        wlr-which-key
      ];

      xdg.configFile."wlr-which-key/config.yaml".text = ''
        font: ${osConfig.fonts.nerd} 12
        background: "#1e1e2e"
        color: "#ffffff"
        border: "#b4befe"
        padding: 12
        border_width: 1
        corner_r: 8

        anchor: bottom-right
        margin_right: 12
        margin_bottom: 12

        menu:
          - key: "m"
            desc: Monitor Configuration
            cmd: quick-terminal hyprmoncfg
          - key: "p"
            desc: Noctalia Panels
            submenu:
              - key: "b"
                desc: Bluetooth
                cmd: noctalia msg panel-toggle control-center bluetooth
              - key: "c"
                desc: Calendar
                cmd: noctalia msg panel-toggle control-center calendar
              - key: "h"
                desc: Home Assistant
                cmd: noctalia msg panel-toggle pozzoo/hassio:entity_manager
              - key: "k"
                desc: Hyprland Keybinds
                cmd: noctalia msg panel-toggle kenn/keybind-cheatsheet:cheatsheet
              - key: "n"
                desc: Network
                cmd: noctalia msg panel-toggle control-center network
              - key: "t"
                desc: Tailscale
                cmd: noctalia msg panel-toggle davemhammer/tailscale:manager
              - key: "v"
                desc: Volume
                cmd: noctalia msg panel-toggle control-center audio
              - key: "w"
                desc: World Clock
                cmd: noctalia msg panel-toggle noctalia/world_clock:panel
          - key: "a"
            desc: Apps
            submenu:
              - key: "b"
                desc: Default Browser - Helium
                cmd: vicinae vicinae://launch/applications/helium
              - key: "f"
                desc: Firefox
                cmd: vicinae vicinae://launch/applications/firefox
              - key: "t"
                desc: Telegram
                cmd: vicinae vicinae://launch/applications/org.telegram
              - key: "d"
                desc: Discord
                cmd: vicinae vicinae://launch/applications/vesktop
              - key: "s"
                desc: Slack
                cmd: vicinae vicinae://launch/applications/slack
              - key: "w"
                desc: Microsoft Teams
                cmd: vicinae vicinae://launch/applications/teams-for-linux
              - key: "m"
                desc: SONE
                cmd: vicinae vicinae://launch/applications/SONE
          - key: "e"
            desc: Execute
            submenu:
              - key: "w"
                desc: Emoji Selector
                cmd: vicinae vicinae://launch/core/search-emojis
              - key: "e"
                desc: File Manager
                cmd: quick-terminal yazi
              - key: "p"
                desc: Task Manager
                cmd: quick-terminal btop
              - key: "t"
                desc: Todo
                cmd: quick-terminal tuxedo
              - key: "b"
                desc: Bluetooth
                cmd: quick-terminal bluetui
              - key: "v"
                desc: Volume
                cmd: quick-terminal wiremix
              - key: "c"
                desc: Color Picker
                cmd: hyprpicker | wl-copy
              - key: "s"
                desc: Systemd Services
                cmd: quick-terminal systemctl-tui -s user
          - key: "s"
            desc: Screenshot
            submenu:
              - key: "f"
                desc: Fullscreen
                cmd: screenshot
              - key: "r"
                desc: Region
                cmd: noctalia msg screenshot-region
              - key: "s"
                desc: Fullscreen with Edit
                cmd: noctalia msg screenshot-fullscreen
          - key: "r"
            desc: Record Screen
            submenu:
              - key: "r"
                desc: Normal Recording
                cmd: noctalia msg plugin noctalia/screen_recorder:service all start focused
              - key: "s"
                desc: Stop Recording
                cmd: noctalia msg plugin noctalia/screen_recorder:service all stop
          - key: "n"
            desc: Notifications
            submenu:
              - key: "c"
                desc: Clear Active
                cmd: system-action notifications clear-active
              - key: "x"
                desc: Clear History
                cmd: system-action notifications clear-history
              - key: "h"
                desc: Show History
                cmd: system-action notifications show-history
              - key: "d"
                desc: Toggle Do Not Disturb
                cmd: system-action notifications toggle-dnd
      '';
    };
  };
}
