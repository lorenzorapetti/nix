{den, ...}: {
  den.aspects.networking.networkmanager = {
    includes = [
      den.aspects.networking.firewall
    ];

    nixos = {
      networking.networkmanager.enable = true;
      systemd.network.wait-online.enable = false;
      boot.initrd.systemd.network.wait-online.enable = false;
      services.resolved.enable = true;

      users.groups = {
        networkmanager = {};
      };
    };
  };
}
