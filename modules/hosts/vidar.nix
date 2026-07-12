{den, ...}: {
  # Vidar host with user Lorenzo.
  # It will automatically create a den.aspects.vidar and den.aspects.lorenzo
  den.hosts.x86_64-linux.vidar.users.lorenzo = {};

  den.aspects.vidar = {
    includes = with den.aspects; [
      base
      hardware.cpu-amd
      hardware.igpu-amd
      hardware.firmware
      theming.catppuccin
      desktop.bluetooth
      desktop.hyprland
    ];
  };
}
