{
  den.aspects.zagreus.homeManager.programs.noctalia.settings = {
    lockscreen = {
      fingerprint = true;
      allow_empty_password = true;
    };

    lockscreen_widgets = {
      enabled = true;
      widget_order = ["lockscreen-login-box@HDMI-A-1" "lockscreen-login-box@DP-1"];

      grid = {
        cell_size = 16;
        major_interval = 4;
        visible = true;
      };

      widget = {
        "lockscreen-login-box@DP-1" = {
          box_height = 70.0;
          box_width = 400.0;
          cx = 1536.0;
          cy = 1522.0;
          output = "DP-1";
          rotation = 0.0;
          type = "login_box";

          settings = {
            background_color = "surface_variant";
            background_opacity = 0.88;
            background_radius = 12.0;
            center_password_text = false;
            input_opacity = 1.0;
            input_radius = 6.0;
            layout = "compact";
            show_caps_lock = true;
            show_keyboard_layout = false;
            show_login_button = false;
            show_media = true;
            show_session_buttons = true;
            show_unlock_hint = true;
            show_weather = true;
          };
        };

        "lockscreen-login-box@HDMI-A-1" = {
          box_height = 70.0;
          box_width = 400.0;
          cx = 960.0;
          cy = 1083.0;
          output = "HDMI-A-1";
          rotation = 0.0;
          type = "login_box";

          settings = {
            background_color = "surface_variant";
            background_opacity = 0.88;
            background_radius = 12.0;
            center_password_text = false;
            input_opacity = 1.0;
            input_radius = 6.0;
            layout = "compact";
            show_caps_lock = true;
            show_keyboard_layout = true;
            show_login_button = false;
            show_media = true;
            show_session_buttons = true;
            show_unlock_hint = true;
            show_weather = true;
          };
        };
      };
    };
  };
}
