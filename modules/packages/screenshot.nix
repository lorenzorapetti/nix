{
  perSystem = {pkgs, ...}: {
    packages.screenshot = pkgs.writeShellApplication {
      name = "screenshot";
      runtimeInputs = with pkgs; [grim jq];
      text = ''
        OUTPUT_DIR="$HOME/Pictures/Screenshots"

        if [[ ! -d $OUTPUT_DIR ]]; then
          mkdir -p "$OUTPUT_DIR"
        fi

        FILENAME="$(date +'%Y-%m-%d-%H%M').png"
        FILEPATH="$OUTPUT_DIR/$FILENAME"

        MODE="''${1:-fullscreen}"

        case "$MODE" in
        fullscreen)
            SELECTOR="$(hyprctl monitors -j | jq -r '.[] | select(.focused==true).name')"
            grim -o "$SELECTOR" "$FILEPATH"
            ;;
        esac
      '';
    };
  };

  den.default.homeManager = {self', ...}: {
    home.packages = [self'.packages.screenshot];
  };
}
