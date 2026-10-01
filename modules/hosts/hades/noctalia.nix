{lib, ...}: {
  den.aspects.hades.homeManager.programs.noctalia.settings = {
    lockscreen = {
      fingerprint = true;
      allow_empty_password = true;
    };

    idle.behavior = {
      "Reduce Brightness" = {
        command = lib.mkForce "brightnessctl -s -d intel_backlight set 10%";
        resume_command = lib.mkForce "brightnessctl -r -d intel_backlight";
      };
      "Keyboard Brightness" = {
        command = lib.mkForce "brightnessctl -s -d framework_laptop::kbd_backlight set 0%";
        resume_command = lib.mkForce "brightnessctl -r -d framework_laptop::kbd_backlight";
      };
    };
  };
}
