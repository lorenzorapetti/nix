{lib, ...}: {
  services.hypridle = {
    enable = lib.mkDefault true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "niri msg action power-on-monitors";
      };

      listener = [
        {
          timeout = 180;
          on-timeout = "brightnessctl -s set 10";
          on-resume = "brightnessctl -r";
        }

        {
          timeout = 300;
          on-timeout = "loginctl lock-session";
        }

        {
          timeout = 420;
          on-timeout = "niri msg power-off-monitors";
          on-resume = "niri msg power-on-monitors && brightnessctl -r";
        }

        {
          timeout = 600;
          on-timeout = "systemctl suspend-then-hibernate";
        }
      ];
    };
  };
}
