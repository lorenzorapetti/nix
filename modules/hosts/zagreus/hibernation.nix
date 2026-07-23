{...}: {
  # Recompute after any swapfile resize/recreate or reinstall:
  #   sudo btrfs inspect-internal map-swapfile -r /swap/swapfile
  den.aspects.zagreus.nixos = {
    # boot.resumeDevice = "/dev/disk/by-partlabel/disk-nvme0n1-root";
    # boot.kernelParams = ["resume_offset=REPLACE_WITH_MAP_SWAPFILE_OUTPUT"];
  };
}
