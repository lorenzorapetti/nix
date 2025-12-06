{perSystem, ...}:
perSystem.self.mkScript {
  name = "awww-switch";
  text =
    # bash
    ''
      WALLPAPER_DIR="$HOME/nix/wallpapers/catppuccin"
      RANDOM_WALLPAPER=$(find "$WALLPAPER_DIR" -type f | shuf -n 1)

      if [ -n "$RANDOM_WALLPAPER" ]; then
          awww img -t none "$RANDOM_WALLPAPER"
      fi
    '';
}
