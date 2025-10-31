{
  config,
  lib,
  ...
}:
with lib; let
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
    };

    spawn-at-startup = [];

    binds = with config.lib.niri.actions;
      attrsets.mergeAttrsList [
        {
          "Mod+Shift+Slash".action = show-hotkey-overlay;
          "Mod+Return".action = spawn "alacritty";
          "Mod+B".action = spawn "zen-twilight";
        }
        (binds {
          suffixes.H = "column-left";
          suffixes.J = "window-down";
          suffixes.K = "window-up";
          suffixes.L = "column-right";
          prefixes."Mod" = "focus";
          prefixes."Mod+Shift" = "move";
        })
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
          prefixes."Mod+Shift" = "move-window-to";
        })
      ];
  };
}
