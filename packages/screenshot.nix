{
  pkgs,
  perSystem,
  ...
}:
perSystem.self.mkScript {
  path = with pkgs; [wayfreeze grim slurp satty wl-clipboard];
  name = "screenshot";
  text =
    # bash
    ''
      OUTPUT_DIR="''${XDG_PICTURES_DIR:-''$HOME/Pictures}}"

      if [[ ! -d "''$OUTPUT_DIR" ]]; then
        mkdir -p "''$OUTPUT_DIR"
      fi

      pkill slurp && exit 0

      MODE="''${1:-region}"
      PROCESSING="''${2:-slurp}"

      # Select based on mode
      case "$MODE" in
        region)
          wayfreeze & PID=$!
          sleep .1
          SELECTION=$(slurp 2>/dev/null)
          kill $PID 2>/dev/null
          grim -g "$SELECTION" - |
            satty --filename - \
              --output-filename "$OUTPUT_DIR/screenshot-$(date +'%Y-%m-%d_%H-%M-%S').png" \
              --early-exit \
              --actions-on-enter save-to-clipboard \
              --save-after-copy \
              --copy-command 'wl-copy'
          ;;
        fullscreen)
          SELECTION=$(niri msg -j focused-output | jq -r '.name')
          grim -o "$SELECTION" - |
            satty --filename - \
              --output-filename "$OUTPUT_DIR/screenshot-$(date +'%Y-%m-%d_%H-%M-%S').png" \
              --early-exit \
              --actions-on-enter save-to-clipboard \
              --save-after-copy \
              --copy-command 'wl-copy'
          ;;
      esac
    '';
}
