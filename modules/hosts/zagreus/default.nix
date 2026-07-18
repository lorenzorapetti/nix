{den, ...}: {
  # Zagreus host with user Lorenzo.
  # It will automatically create a den.aspects.zagreus and den.aspects.lorenzo
  den.hosts.x86_64-linux.zagreus.users.lorenzo = {};

  den.aspects.zagreus = {
    includes = with den.aspects; [
      base
      hardware.cpu-amd
      hardware.igpu-amd
      hardware.firmware
      theming.catppuccin
      desktop.bluetooth
      desktop.hyprland
      development
      docker
    ];

    nixos = {
      hardware.facter.reportPath = ./facter.json;
    };
  };
}
