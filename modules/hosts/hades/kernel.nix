{den, ...}: {
  den.aspects.hades = {
    includes = [
      den.aspects.boot.kernel-cachyos
    ];

    nixos = {pkgs, ...}: {
      boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-bore-lto-x86_64-v3;

      boot.kernelParams = [
        "nowatchdog"
        # Cap the TTM GPU page pool (default: half of RAM) at 4 GiB; 1048576 × 4 KiB pages.
        "ttm.page_pool_size=1048576"
      ];
    };
  };
}
