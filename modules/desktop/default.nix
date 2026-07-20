{den, ...}: {
  den.aspects.desktop = {
    includes = with den.aspects; [
      hardware.firmware
      desktop.sound
    ];

    nixos = {
      programs.dconf.enable = true;
    };
  };
}
