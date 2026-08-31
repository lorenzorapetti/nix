{
  den.aspects.hades.nixos = {
    boot.resumeDevice = "/dev/disk/by-partlabel/disk-nvme0n1-root";
    boot.kernelParams = ["resume_offset=533760"];

    # suspend-then-hibernate: hold S3 sleep for 30 min, then hibernate to the
    # /swap swapfile. Only when on battery -- docked/charging, just stay suspended.
    systemd.sleep.settings.Sleep = {
      HibernateDelaySec = "30min";
      HibernateOnACPower = false;
    };
  };
}
