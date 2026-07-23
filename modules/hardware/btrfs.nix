{
  den.aspects.hardware.btrfs = {
    nixos = {
      services.btrfs.autoScrub = {
        enable = true;
        interval = "weekly";
      };

      services.smartd.enable = true;
    };
  };
}
