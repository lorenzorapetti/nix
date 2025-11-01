{
  config,
  lib,
  pkgs,
  perSystem,
  ...
}: let
  inherit (lib) map replaceStrings attrNames attrValues isList head tail concatMap listToAttrs;

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
          options = "compose:ralt,ctrl:nocaps";
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
      {
        geometry-corner-radius = cornerRadius 8.0;
        clip-to-geometry = true;
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

      zen-twilight = perSystem.zen-browser.twilight;

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
    in
      lib.attrsets.mergeAttrsList [
        {
          "Mod+Shift+Slash".action = show-hotkey-overlay;
          "Mod+Return" = bind "Open Terminal" (spawn "${getExe pkgs.alacritty}");
          "Mod+B" = bind "Open Browser" (spawn "${getExe zen-twilight}");

          "Mod+Q" = bind "Close Window" close-window;
          "Mod+Ctrl+E" = bind "Toggle Overview" toggle-overview;

          # Launchers
          "Mod+Shift+Space" = bind "Open 1Password Quick Access" (spawn "1password" "--quick-access");
          "Mod+Space" = bind "Open Launcher" (menu "toggle");
          "Mod+Y" = bind "Open Clipboard History" (menu "vicinae://extensions/vicinae/clipboard/history");
          "Mod+E" = bind "Open Emoji Selector" (menu "vicinae://extensions/vicinae/vicinae/search-emojis");
        }
        # Media
        {
          XF86AudioRaiseVolume = bindMedia (spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%+");
          XF86AudioLowerVolume = bindMedia (spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%-");
          XF86AudioMute = bindMedia (spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle");
          XF86AudioMicMute = bindMedia (spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle");

          XF86AudioNext = bindMedia (spawn "${playerctl}" "next");
          XF86AudioPrev = bindMedia (spawn "${playerctl}" "previous");
          XF86AudioPlay = bindMedia (spawn "${playerctl}" "play-pause");
          XF86AudioPause = bindMedia (spawn "${playerctl}" "play-pause");
          XF86AudioStop = bindMedia (spawn "${playerctl}" "stop");

          XF86MonBrightnessUp = bindMedia (spawn "${brightnessctl}" "s" "+5%");
          XF86MonBrightnessDown = bindMedia (spawn "${brightnessctl}" "s" "5%-");
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
          suffixes = builtins.listToAttrs (
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
          "Mod+Ctrl+E" = bind "Quit Niri" quit;
          "Ctrl+Alt+Delete" = bind "Quit Niri" quit;
        }
      ];
  };
}
