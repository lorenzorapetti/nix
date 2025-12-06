{
  config,
  osConfig,
  lib,
  pkgs,
  perSystem,
  ...
}: let
  inherit (lib) map replaceStrings attrNames attrValues isList head tail concatMap listToAttrs;
  inherit (osConfig) monitors;

  # This combines prefixes in the form
  #
  # `prefixes.<prefix-name> = <prefix-action>`
  #
  # with suffixes in the form
  #
  # `suffixes.<suffix-name> = <suffix-action>`
  #
  # to generate a combination of bindings in the form
  #
  # `"<prefix-name>+<suffix-name>".action = "<prefix-action>-<suffix-action>";`
  #
  # The suffix value can be a list: in this case the first value of the list
  # becomes `<suffix-action>`, the other values get used as arguments.
  #
  # You can provide a list of substitutions to do for the action name. If, for example,
  # you have:
  #
  # ```
  # suffixes."Left" = "column-left";
  # prefixes."Mod+Shift" = "focus-monitor";
  # ```
  #
  # the action is "focus-monitor-column-left" which isn't an accepted value.
  # With `substitutions."monitor-column" = "monitor";`, the action becomes
  # "focus-monitor-left".
  binds = {
    suffixes,
    prefixes,
    substitutions ? {},
  }: let
    replacer = replaceStrings (attrNames substitutions) (attrValues substitutions);
    format = prefix: suffix: let
      actual-suffix =
        if isList suffix.action
        then {
          action = head suffix.action;
          args = tail suffix.action;
        }
        else {
          inherit (suffix) action;
          args = [];
        };

      action = replacer "${prefix.action}-${actual-suffix.action}";
    in {
      name = "${prefix.key}+${suffix.key}";
      value.action.${action} = actual-suffix.args;
    };
    pairs = attrs: fn:
      concatMap (
        key:
          fn {
            inherit key;
            action = attrs.${key};
          }
      ) (attrNames attrs);
  in
    listToAttrs (pairs prefixes (prefix: pairs suffixes (suffix: [(format prefix suffix)])));
in {
  programs.niri.settings = {
    hotkey-overlay.skip-at-startup = true;
    hotkey-overlay.hide-not-bound = true;

    # Prefer Server Side Decorations
    prefer-no-csd = true;

    input = {
      keyboard = {
        repeat-delay = 250;
        repeat-rate = 70;

        xkb = {
          layout = "us";
          options = "compose:ralt";
        };
      };

      mouse = {
        accel-profile = "flat";
        accel-speed = 0.2;
      };

      touchpad = {
        accel-profile = "flat";
        accel-speed = 0.2;
        disabled-on-external-mouse = true;
      };

      focus-follows-mouse = {
        enable = true;
        max-scroll-amount = "95%";
      };

      warp-mouse-to-focus.enable = true;
      workspace-auto-back-and-forth = true;
    };

    outputs = listToAttrs (map (monitor: {
        inherit (monitor) name;
        value = {
          backdrop-color = config.lib.stylix.colors.base01;
          background-color = config.lib.stylix.colors.base01;

          mode = {
            inherit (monitor) width height refresh;
          };

          inherit (monitor) position scale;
        };
      })
      monitors);

    layout = {
      gaps = 12;

      center-focused-column = "never";

      default-column-display = "normal";

      preset-column-widths = [
        {proportion = 0.33333;}
        {proportion = 0.5;}
        {proportion = 0.66667;}
      ];

      default-column-width.proportion = 0.5;

      focus-ring = {
        width = 2;

        active.gradient = {
          from = "#8caaee";
          to = "#f4b8e4";
          angle = 135;
          relative-to = "workspace-view";
        };
        inactive.gradient = {
          from = "#8e7ab5";
          to = "#756ab6";
          angle = 135;
          relative-to = "workspace-view";
          in' = "oklch shorter hue";
        };
      };

      border = {
        width = 3;

        active.color = "#b7bdf8";
        inactive.color = "#505050";
        urgent.color = "#9b0000";
      };

      shadow = {
        enable = true;
        softness = 50;
        spread = 5;
        offset.x = 0;
        offset.y = 5;

        color = "#0002";
      };
    };

    gestures.hot-corners.enable = false;

    spawn-at-startup = [
      {sh = "mako";}
      {sh = "1password --silent";}
      {sh = "awww-switch";}
      {argv = ["nm-applet" "--indicator"];}
    ];

    window-rules = let
      cornerRadius = radius: {
        bottom-left = radius;
        bottom-right = radius;
        top-left = radius;
        top-right = radius;
      };
    in [
      # Border radius for all windows
      {
        geometry-corner-radius = cornerRadius 8.0;
        clip-to-geometry = true;
      }
      {
        matches = [
          {app-id = "^1Password$";}
        ];
        block-out-from = "screencast";
        open-floating = true;
      }
      {
        matches = [
          {app-id = "^(nm-connection-editor|\.blueman-manager-wrapped|imv|mpv|org.pulseaudio.pavucontrol)";}
        ];
        open-floating = true;
      }
      {
        matches = [
          {app-id = "^quick-terminal";}
        ];
        open-floating = true;
        open-maximized = true;
        default-column-width.proportion = 0.9;
        default-window-height.proportion = 0.8;
      }
      {
        matches = [
          {
            app-id = "steam";
            title = "^notificationtoasts_\d+_desktop$";
          }
        ];
        default-floating-position = {
          x = 10;
          y = 10;
          relative-to = "bottom-right";
        };
      }
      {
        matches = [
          {app-id = "^(brave-browser|dev\.zed\.Zed|firefox|zen|zen-twilight)$";}
        ];
        open-maximized = true;
      }
      {
        matches = [
          {title = "^(Picture in picture)$";}
        ];
        open-floating = true;
        default-floating-position = {
          x = 10;
          y = 10;
          relative-to = "bottom-right";
        };
      }
      {
        matches = [
          {title = "^(Vicinae Launcher)$";}
        ];
        open-floating = true;
        focus-ring.enable = false;
        shadow.enable = false;
      }
    ];

    switch-events = with config.lib.niri.actions; let
      sh = spawn "sh" "-c";
    in {
      lid-close.action = sh "hyprlock --no-fade-in && brightnessctl -sd rgb:kbd_backlight set 0 && niri msg action power-off-monitors";
      lid-open.action = sh "brightnessctl -rd rgb:kbd_backlight && niri msg action power-on-monitors && brightnessctl -r";
    };

    binds = with config.lib.niri.actions; let
      inherit (lib) getExe range;
      inherit (lib.attrsets) mergeAttrsList;

      vicinae = getExe perSystem.vicinae.default;
      playerctl = getExe pkgs.playerctl;
      brightnessctl = getExe pkgs.brightnessctl;

      menu = args: spawn "${vicinae}" args;

      bind = desc: action: {
        inherit action;
        hotkey-overlay.title = desc;
      };

      bindMedia = action: {
        inherit action;
        allow-when-locked = true;
      };

      focus-or-open = {
        app,
        letter,
        id,
      }: {
        "Shift+Ctrl+Alt+Super+${letter}" = bind "Focus Or Open ${app}" (spawn-sh "${perSystem.self.focus-or-open}/bin/focus-or-open ${app} --app-id ${id}");
      };

      focusOrOpenBinds = apps: mergeAttrsList (map focus-or-open apps);

      swayosdEnabled = config.services.swayosd.enable;

      audio =
        if swayosdEnabled
        then {
          raise = "swayosd-client --output-volume raise";
          lower = "swayosd-client --output-volume lower";
          mute = "swayosd-client --output-volume mute-toggle";
          micMute = "swayosd-client --input-volume mute-toggle";
        }
        else {
          raise = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+";
          lower = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
          mute = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
          micMute = "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
        };

      brightness =
        if swayosdEnabled
        then {
          raise = "swayosd-client --brightness raise";
          lower = "swayosd-client --brightness lower";
        }
        else {
          raise = "${brightnessctl} s +5%";
          lower = "${brightnessctl} s 5%-";
        };

      player =
        if swayosdEnabled
        then {
          playPause = "swayosd-client --playerctl play-pause";
        }
        else {
          playPause = "${playerctl} play-pause";
        };
    in
      lib.attrsets.mergeAttrsList [
        {
          "Mod+Shift+Slash".action = show-hotkey-overlay;
          "Mod+Return" = bind "Open Terminal" (spawn "${getExe pkgs.wezterm}");
          "Mod+B" = bind "Open Browser" (spawn "${getExe pkgs.brave}");
          "Mod+E" = bind "Open File Manager" (spawn-sh "alacritty --class quick-terminal -e yazi");

          "Mod+Q" = bind "Close Window" close-window;
          "Mod+Ctrl+E" = bind "Toggle Overview" toggle-overview;

          # Launchers
          "Mod+Shift+Space" = bind "Open 1Password Quick Access" (spawn "1password" "--quick-access");
          "Mod+Space" = bind "Open Launcher" (menu "toggle");
          "Mod+Y" = bind "Open Clipboard History" (menu "vicinae://extensions/vicinae/clipboard/history");
          "Mod+Shift+E" = bind "Open Emoji Selector" (menu "vicinae://extensions/vicinae/vicinae/search-emojis");

          "Mod+Ctrl+B" = bind "Open Bluetooth" (spawn "blueman-manager");
          "Mod+Ctrl+V" = bind "Open Volume Control" (spawn "pavucontrol");
        }
        # Media
        {
          XF86AudioRaiseVolume = bindMedia (spawn-sh audio.raise);
          XF86AudioLowerVolume = bindMedia (spawn-sh audio.lower);
          XF86AudioMute = bindMedia (spawn-sh audio.mute);
          XF86AudioMicMute = bindMedia (spawn-sh audio.micMute);

          XF86AudioNext = bindMedia (spawn "${playerctl}" "next");
          XF86AudioPrev = bindMedia (spawn "${playerctl}" "previous");
          XF86AudioPlay = bindMedia (spawn-sh player.playPause);
          XF86AudioPause = bindMedia (spawn-sh player.playPause);
          XF86AudioStop = bindMedia (spawn "${playerctl}" "stop");

          XF86MonBrightnessUp = bindMedia (spawn-sh brightness.raise);
          XF86MonBrightnessDown = bindMedia (spawn-sh brightness.lower);
        }
        # Screenshot
        {
          Print = bind "Screenshot" (spawn-sh "screenshot region");
          "Ctrl+Print" = bind "Screenshot Entire Screen" (spawn-sh "screenshot fullscreen");
        }
        # Focus & Movement
        (binds {
          suffixes.Left = "column-left";
          suffixes.Down = "window-or-workspace-down";
          suffixes.Up = "window-or-workspace-up";
          suffixes.Right = "column-right";
          suffixes.H = "column-left";
          suffixes.J = "window-or-workspace-down";
          suffixes.K = "window-or-workspace-up";
          suffixes.L = "column-right";
          prefixes."Mod" = "focus";
          prefixes."Mod+Ctrl" = "move";
          prefixes."Mod+Shift" = "focus-monitor";
          prefixes."Mod+Shift+Ctrl" = "move-column-to-monitor";
          substitutions."move-window-or-workspace-down" = "move-window-down-or-to-workspace-down";
          substitutions."move-window-or-workspace-up" = "move-window-up-or-to-workspace-up";
          substitutions."monitor-column" = "monitor";
          substitutions."monitor-window-or-workspace" = "monitor";
        })
        # Focus or Open Apps
        (focusOrOpenBinds [
          {
            app = "zeditor";
            letter = "Z";
            id = "dev.zed.Zed";
          }
          {
            app = "brave";
            letter = "B";
            id = "brave-browser";
          }
          {
            app = "telegram-desktop";
            letter = "T";
            id = "org.telegram.desktop";
          }
          {
            app = "vesktop";
            letter = "D";
            id = "vesktop";
          }
          {
            app = "alacritty";
            letter = "A";
            id = "Alacritty";
          }
        ])
        (binds {
          suffixes.Home = "first";
          suffixes.End = "last";
          prefixes."Mod" = "focus-column";
          prefixes."Mod+Ctrl" = "move-column-to";
        })
        {
          "Mod+WheelScrollDown" = {
            action = focus-workspace-down;
            cooldown-ms = 150;
          };
          "Mod+WheelScrollUp" = {
            action = focus-workspace-up;
            cooldown-ms = 150;
          };
          "Mod+Ctrl+WheelScrollDown" = {
            action = move-column-to-workspace-down;
            cooldown-ms = 150;
          };
          "Mod+Ctrl+WheelScrollUp" = {
            action = move-column-to-workspace-up;
            cooldown-ms = 150;
          };

          "Mod+WheelScrollRight" = {action = focus-column-right;};
          "Mod+WheelScrollLeft" = {action = focus-column-left;};
          "Mod+Ctrl+WheelScrollRight" = {action = move-column-right;};
          "Mod+Ctrl+WheelScrollLeft" = {action = move-column-left;};
        }
        (binds {
          suffixes = listToAttrs (
            map (n: {
              name = toString n;
              value = [
                "workspace"
                n
              ];
            }) (range 1 9)
          );
          prefixes."Mod" = "focus";
          prefixes."Mod+Ctrl" = "move-column-to";
        })
        {
          "Mod+0".action.focus-workspace = 10;
          "Mod+Ctrl+0".action.move-column-to-workspace = 10;
          "Mod+Tab".action = focus-workspace-previous;

          "Mod+BracketLeft".action = consume-or-expel-window-left;
          "Mod+BracketRight".action = consume-or-expel-window-right;

          "Mod+Comma".action = consume-window-into-column;
          "Mod+Period".action = expel-window-from-column;
        }
        {
          "Mod+R".action = switch-preset-column-width;
          "Mod+Shift+R".action = switch-preset-window-height;
          "Mod+Ctrl+R".action = reset-window-height;
          "Mod+M".action = maximize-column;
          "Mod+Shift+M".action = fullscreen-window;

          "Mod+Ctrl+F".action = expand-column-to-available-width;

          "Mod+C".action = center-column;

          "Mod+Ctrl+C".action = center-visible-columns;

          "Mod+Minus".action.set-column-width = "-10%";
          "Mod+Equal".action.set-column-width = "+10%";

          "Mod+Shift+Minus".action.set-window-height = "-10%";
          "Mod+Shift+Equal".action.set-window-height = "+10%";

          "Mod+F".action = toggle-window-floating;
          "Mod+Shift+F".action = switch-focus-between-floating-and-tiling;

          "Mod+W".action = toggle-column-tabbed-display;
        }
        {
          "Mod+Ctrl+X" = bind "Quit Niri" quit;
          "Ctrl+Alt+Delete" = bind "Quit Niri" quit;
        }
      ];

    xwayland-satellite = {
      enable = true;
      path = "${lib.getExe pkgs.xwayland-satellite-unstable}";
    };
  };
}
