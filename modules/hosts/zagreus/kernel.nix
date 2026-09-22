{den, ...}: {
  den.aspects.zagreus = {
    includes = [
      den.aspects.boot.kernel-cachyos
    ];

    nixos = {pkgs, ...}: {
      boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-bore-lto-zen4;

      powerManagement.cpuFreqGovernor = "performance";

      boot.kernelParams = [
        "nowatchdog"
        "mitigations=off"
      ];
    };
  };
}
