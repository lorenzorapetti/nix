{
  den.aspects.hades.nixos = {
    boot.resumeDevice = "/dev/disk/by-partlabel/disk-nvme0n1-root";
    boot.kernelParams = ["resume_offset=533760"];
  };
}
