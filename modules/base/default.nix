{den, ...}: {
  den.aspects.base = {
    includes = with den.aspects; [
      hardware.ssd
      boot.limine
      networking.networkmanager
    ];
  };
}
