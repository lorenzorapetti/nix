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

      services.udev.extraRules = ''
        # Keychron Ultra-Link 8K USB receiver: expose hidraw device to non-root users.
        KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="3434", ATTRS{idProduct}=="d028", MODE="0660", GROUP="wheel", TAG+="uaccess", TAG+="udev-acl"
      '';
    };

    homeManager = {
      home.pointerCursor.enable = true;
    };
  };
}
