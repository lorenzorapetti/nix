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
          - key: "p"
            desc: Power
            cmd: system-action session menu-toggle
          - key: "m"
            desc: Monitor Configuration
            cmd: quick-terminal hyprmoncfg
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
                desc: Full Screen
                cmd: system-action screenshot fullscreen
              - key: "r"
                desc: Region
                cmd: system-action screenshot region
              - key: "w"
                desc: Windows
                cmd: screenshot windows
              - key: "s"
                desc: Smart
                cmd: screenshot smart
          - key: "r"
            desc: Record Screen
            submenu:
              - key: "r"
                desc: Normal Recording
                cmd: system-action screenrecord start
              - key: "a"
                desc: With Desktop Audio
                cmd: screenrecord --with-desktop-audio
              - key: "f"
                desc: With Full Audio (Dekstop and Mic)
                cmd: screenrecord --with-desktop-audio --with-microphone-audio
              - key: "s"
                desc: Stop Recording
                cmd: system-action screenrecord stop
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
