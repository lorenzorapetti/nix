{...}: {
  # Suspend-to-disk (hibernation) resume config for zagreus.
  #
  # These two values are machine-specific and MUST be filled in from the running
  # zagreus host before enabling. Leaving them commented keeps eval clean while the
  # values are unknown -- an active but wrong resume_offset can corrupt a resume.
  #
  # Determine them on zagreus AFTER the /swap/swapfile has been resized to 40G
  # (see disko.nix / the plan's manual resize step), because the offset changes
  # whenever the swapfile is recreated:
  #
  #   # physical offset of the swapfile within btrfs:
  #   sudo btrfs inspect-internal map-swapfile -r /swap/swapfile
  #
  #   # stable path to the btrfs partition holding /swap (NOT the whole disk):
  #   ls -l /dev/disk/by-partlabel/        # disko root partition, e.g. disk-nvme0n1-root
  #
  # Then uncomment and set:
  den.aspects.zagreus.nixos = {
    # boot.resumeDevice = "/dev/disk/by-partlabel/disk-nvme0n1-root";
    # boot.kernelParams = ["resume_offset=REPLACE_WITH_MAP_SWAPFILE_OUTPUT"];
  };
}
