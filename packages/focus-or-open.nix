{
  pkgs,
  perSystem,
  ...
}:
perSystem.self.mkScript rec {
  path = with pkgs; [slurp libnotify v4l-utils ffmpeg gpu-screen-recorder];
  name = "focus-or-open";
  text =
    # bash
    ''
      if [[ "$DESKTOP_SESSION" != "niri" && "$DESKTOP_SESSION" != "hyprland" ]]; then
          notify-send "Unsupported Desktop" "This script only works with niri or hyprland. Current session: ''${DESKTOP_SESSION:-none}"
          exit 1
      fi

      print_usage() {
          echo "Usage: ${name} <command> [--app-id <id>] [--app-title <title>]"
      }

      build_jq_filter() {
          local app_id="$1"
          local app_title="$2"
          local filter="."

          if [[ -n "$app_id" && -n "$app_title" ]]; then
              filter=".[] | select(.app_id == \"$app_id\" or .title == \"$app_title\") | .id"
          elif [[ -n "$app_id" ]]; then
              filter=".[] | select(.app_id == \"$app_id\") | .id"
          elif [[ -n "$app_title" ]]; then
              filter=".[] | select(.title == \"$app_title\") | .id"
          fi

          echo "$filter"
      }

      COMMAND=""
      APP_ID=""
      APP_TITLE=""

      while [ $# -gt 0 ]; do
          case $1 in
              --app-id)
                  APP_ID="$2"
                  shift 2
                  ;;
              --app-title)
                  APP_TITLE="$2"
                  shift 2
                  ;;
              *)
                  if [[ -z "$COMMAND" ]]; then
                      COMMAND="$1"
                  else
                      echo "Error: Unknown argument '$1'"
                      exit 1
                  fi
                  shift
                  ;;
          esac
      done

      if [[ -z "$COMMAND" ]]; then
          echo "Error: Application is required"
          print_usage
          exit 1
      fi

      if [[ -z "$APP_ID" && -z "$APP_TITLE" ]]; then
          echo "Error: At least one of --app-id or --app-title is required"
          print_usage
          exit 1
      fi

      FILTER=$(build_jq_filter "$APP_ID" "$APP_TITLE")

      if [[ "$DESKTOP_SESSION" == "niri" ]]; then
          id=$(niri msg -j windows | jq -r "$FILTER" | head -n1)

          if [[ -n "$id" ]]; then
              niri msg action focus-window --id "$id"
          else
              $COMMAND &
          fi
      fi
    '';
}
