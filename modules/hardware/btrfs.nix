{
  den.aspects.hardware.btrfs = {
    nixos = {
      services.btrfs.autoScrub = {
        enable = true;
        interval = "weekly";
      };

      services.smartd.enable = true;

      services.btrbk.instances.local = {
        onCalendar = "daily";
        snapshotOnly = true;
        settings = {
          snapshot_preserve_min = "2d";
          snapshot_preserve = "7d";
          volume."/" = {
            subvolume = "home";
            snapshot_dir = "/.snapshots";
          };
        };
      };
    };
  };
}
