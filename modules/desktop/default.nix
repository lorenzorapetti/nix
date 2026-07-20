{den, ...}: {
  den.aspects.desktop = {
    includes = with den.aspects; [
      hardware.firmware
      desktop.sound
    ];

    nixos = {
      programs.dconf.enable = true;

      # Fast, compressed, RAM-backed swap. Default zram priority (5) is higher than a
      # disk swapfile, so runtime swapping hits zram first; only allocates as used.
      zramSwap = {
        enable = true;
        algorithm = "zstd";
        memoryPercent = 50;
      };

      # Bias the kernel toward using (fast) zram aggressively over reclaiming page
      # cache -- appropriate when swap is compressed RAM. Range 0-200 (kernel >=5.8).
      boot.kernel.sysctl."vm.swappiness" = 180;
    };

    homeManager = {
      home.pointerCursor.enable = true;
    };
  };
}
