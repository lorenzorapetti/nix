{inputs, ...}: {
  # Push-to-talk voice-to-text. Recording is toggled by a Hyprland keybind
  # (SUPER + I, see hyprland/config/keybinds.lua) rather than voxtype's evdev
  # hotkey, so the user doesn't need to be in the `input` group.
  den.aspects.desktop.base-applications.homeManager = {inputs', ...}: {
    imports = [inputs.voxtype.homeManagerModules.default];

    programs.voxtype = {
      enable = true;
      # Vulkan whisper.cpp: GPU-accelerated on both the Intel and AMD hosts.
      package = inputs'.voxtype.packages.vulkan;
      model.name = "large-v3-turbo";
      service.enable = true;
      settings = {
        hotkey = {
          enabled = false;
          mode = "toggle";
        };
        # Constrained auto-detect: only English and Italian.
        whisper = {
          language = ["en" "it"];
          # Load the model only while recording, so the idle daemon holds no
          # RAM/VRAM. `voxtype record` needs the daemon, so it can't go entirely.
          on_demand_loading = true;
        };
      };
    };
  };
}
