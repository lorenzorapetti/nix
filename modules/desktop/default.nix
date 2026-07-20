{den, ...}: {
  den.aspects.desktop = {
    includes = with den.aspects; [
      hardware.firmware
      desktop.sound
    ];
  };
}
