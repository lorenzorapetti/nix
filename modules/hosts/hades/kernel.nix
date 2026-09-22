{den, ...}: {
  den.aspects.hades = {
    includes = [
      den.aspects.boot.kernel-cachyos
    ];

    nixos = {pkgs, ...}: {
      boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-bore-lto-x86_64-v3;

      boot.kernelParams = [
        "nowatchdog"
      ];
    };
  };
}
