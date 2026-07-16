{
  perSystem = {pkgs, ...}: {
    packages.zellij-sesh = pkgs.writeShellApplication {
      name = "zellij-sesh";
      runtimeInputs = with pkgs; [zellij zoxide bat eza];
      # Script relies on unset $ZELLIJ / missing zellij sessions as normal,
      # non-error conditions, so keep bash's strict-mode options off.
      bashOptions = [];
      text = ''
        # zellij-sesh: television helper for zellij sessions, layouts, and zoxide paths.
        #
        # Usage:
        #   zellij-sesh [list]        emit entries (default)
        #   zellij-sesh preview LINE  render a preview for the given entry
        #   zellij-sesh open LINE     open/attach/launch the given entry
        #
        # Entry format (icon-prefixed, newline-separated for list):
        #   󱂬 <session>   session   (or "󱂬 <session> (current)" for the active one)
        #    <layout>     layout    (layouts whose name matches a session are skipped)
        #    <path>       zoxide path

        layouts_dir="''${ZELLIJ_LAYOUTS_DIR:-$HOME/.config/zellij/layouts}"

        ICON_SESSION='󱂬'
        ICON_LAYOUT=''
        ICON_PATH=''

        cmd_list() {
          sessions="$(zellij list-sessions -n 2>/dev/null)"

          # --- Sessions -------------------------------------------------------------
          printf '%s\n' "$sessions" | while IFS= read -r line; do
            [ -n "$line" ] || continue
            name="''${line%% *}"
            case "$line" in
            *"(current)"*) printf '%s %s (current)\n' "$ICON_SESSION" "$name" ;;
            *) printf '%s %s\n' "$ICON_SESSION" "$name" ;;
            esac
          done

          # Plain list of session names, used to filter layouts.
          session_names="$(printf '%s\n' "$sessions" | awk 'NF { print $1 }')"

          # --- Layouts --------------------------------------------------------------
          if [ -d "$layouts_dir" ]; then
            for f in "$layouts_dir"/*.kdl; do
              [ -e "$f" ] || continue
              base="$(basename "$f" .kdl)"
              if ! printf '%s\n' "$session_names" | grep -qxF "$base"; then
                printf '%s %s\n' "$ICON_LAYOUT" "$base"
              fi
            done
          fi

          # --- Zoxide paths ---------------------------------------------------------
          zoxide query -l 2>/dev/null | while IFS= read -r path; do
            [ -n "$path" ] || continue
            printf '%s %s\n' "$ICON_PATH" "$path"
          done
        }

        cmd_preview() {
          line="$1"
          value="''${line#* }"
          case "$line" in
          "$ICON_SESSION "*)
            name="''${value% (current)}"
            if [ -f "$layouts_dir/$name.kdl" ]; then
              bat --color=always --style=plain "$layouts_dir/$name.kdl"
            else
              printf 'Zellij session: %s\n' "$name"
            fi
            ;;
          "$ICON_PATH "*)
            eza -la --color=always --icons --group-directories-first "$value"
            ;;
          *)
            bat --color=always --style=plain "$layouts_dir/$value.kdl"
            ;;
          esac
        }

        cmd_open() {
          line="$1"
          value="''${line#* }"
          case "$line" in
          "$ICON_SESSION "*)
            name="''${value% (current)}"
            if [ -n "$ZELLIJ" ]; then
              zellij action switch-session "$name"
            else
              zellij attach --force-run-commands "$name"
            fi
            ;;
          "$ICON_PATH "*)
            path="$value"
            name="$(basename "$path")"
            if zellij list-sessions -ns 2>/dev/null | grep -qxF "$name"; then
              name="$name-$(random_suffix)"
            fi
            if [ -n "$ZELLIJ" ]; then
              zellij attach --create-background "$name" options --default-cwd "$path" &&
                zellij action switch-session "$name"
            else
              cd "$path" && zellij -s "$name"
            fi
            ;;
          *)
            name="$value"
            if [ -n "$ZELLIJ" ]; then
              zellij attach --create-background "$name" options --default-layout "$name" &&
                zellij action switch-session "$name"
            else
              zellij -n "$name" -s "$name"
            fi
            ;;
          esac
        }

        random_suffix() {
          LC_ALL=C tr -dc 'a-z0-9' </dev/urandom | head -c 5
        }

        case "''${1:-list}" in
        preview)
          shift
          cmd_preview "$@"
          ;;
        open)
          shift
          cmd_open "$@"
          ;;
        *) cmd_list ;;
        esac
      '';
    };
  };

  den.default.homeManager = {self', ...}: {
    home.packages = [self'.packages.zellij-sesh];
  };
}
