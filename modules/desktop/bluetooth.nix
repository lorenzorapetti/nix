{den, ...}: {
  den.aspects.desktop.bluetooth = {
    includes = with den.aspects; [
      hardware.bluetooth
    ];

    nixos = {
      services.blueman.enable = true;
    };
  };
}
