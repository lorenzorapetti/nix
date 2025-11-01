{lib, ...}: {
  programs.hyprlock = {
    enable = lib.mkDefault true;

    settings = {
      general = {
        hide_cursor = true;
        ignore_empty_input = true;
        text_trim = true;
      };

      background = [
        {
          path = "screenshot";
          blur_passes = 2;
          contrast = 0.8916;
          brightness = 0.7172;
          vibrancy = 0.1696;
          vibrancy_darkness = 0;
        }
      ];

      label = [
        # TIME HR
        {
          monitor = "";
          text = "cmd[update:1000] echo -e \"$(date +\"%H\")\"";
          color = "rgba(255, 255, 255, 1)";
          shadow_pass = 2;
          shadow_size = 3;
          shadow_color = "rgb(0,0,0)";
          shadow_boost = 1.2;
          font_size = 150;
          font_family = "GeistMono Nerd Font Mono";
          position = "0, -250";
          halign = "center";
          valign = "top";
        }

        # TIME
        {
          monitor = "";
          text = "cmd[update:1000] echo -e \"$(date +\"%M\")\"";
          color = "rgba(255, 255, 255, 1)";
          font_size = 150;
          font_family = "GeistMono Nerd Font Mono";
          position = "0, -420";
          halign = "center";
          valign = "top";
        }

        # DATE
        {
          monitor = "";
          text = "cmd[update:1000] echo -e \"$(date +\"%A %d %b\")\"";
          color = "rgba(255, 255, 255, 1)";
          font_size = 14;
          font_family = "GeistMono Nerd Font Mono";
          position = "0, -130";
          halign = "center";
          valign = "center";
        }
      ];

      input-field = [
        {
          monitor = "";
          size = "350, 60";
          outline_thickness = 2;
          outer_color = "rgba(183, 189, 248, 1)";
          dots_size = 0.1;
          dots_spacing = 1;
          dots_center = true;
          rounding = 14;
          inner_color = "rgba(36, 39, 58, 1)";
          font_color = "rgba(200, 200, 200, 1)";
          fade_on_empty = false;
          font_family = "GeistMono Nerd Font Mono";
          placeholder_text = "";
          hide_input = false;
          position = "0, -470";
          halign = "center";
          valign = "center";
          zindex = 10;
        }
      ];
    };
  };
}
