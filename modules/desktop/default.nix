{den, ...}: {
  den.aspects.desktop = {
    includes = with den.aspects; [
      hardware.firmware
      desktop.sound
      desktop.printing
    ];

    nixos = {
      programs.dconf.enable = true;

      security.polkit = {
        enable = true;
        enablePkexecWrapper = true;
      };

      # Small compressed RAM swap for routine paging. Priority 100 puts it well
      # above the disk swapfile (negative priority) so idle anon pages land in
      # fast zram first; the disk swapfile is left as overflow + hibernation
      # space only. 25% of RAM (~7.6G on a 32G host) keeps the working set roomy
      # and avoids the "big zram starves RAM under load" failure mode.
      zramSwap = {
        enable = true;
        algorithm = "zstd";
        memoryPercent = 25;
        priority = 100;
      };

      # CachyOS kernels enable zswap by default (CONFIG_ZSWAP_DEFAULT_ON). zswap
      # in front of zram is pointless double-compression -- disable it so zram is
      # the only compressed-swap layer. Takes effect after a reboot.
      boot.kernelParams = ["zswap.enabled=0"];

      # Kernel default. With only ~8G of zram, don't page anon memory out any
      # more eagerly than reclaiming page cache; real pressure still spills to
      # zram and then the disk swapfile.
      boot.kernel.sysctl."vm.swappiness" = 60;

      # No swap readahead -- decompressing an extra zram page is never cheaper
      # than faulting the one that was asked for. (Already the CachyOS default;
      # pinned here so it survives a kernel switch.)
      boot.kernel.sysctl."vm.page-cluster" = 0;

      services.udev.extraRules = ''
        # Keychron Mouse
        KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="3434", ATTRS{idProduct}=="0ea0", MODE="0660", GROUP="wheel", TAG+="uaccess", TAG+="udev-acl"
        KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="3434", ATTRS{idProduct}=="d028", MODE="0660", GROUP="wheel", TAG+="uaccess", TAG+="udev-acl"
      '';
    };

    homeManager = {
      home.pointerCursor.enable = true;
    };
  };
}
