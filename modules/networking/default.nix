{
  den.aspects.networking = {
    nixos = {
      networking.nftables.enable = true;
      systemd.network.wait-online.enable = false;
      boot.initrd.systemd.network.wait-online.enable = false;
    };
  };
}
