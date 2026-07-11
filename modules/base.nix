{den, ...}: {
  den.aspects.base = {
    includes = with den.aspects; [
      hardware.ssd
      boot.kernel-latest
      boot.limine
      networking.networkmanager
    ];
  };
}
