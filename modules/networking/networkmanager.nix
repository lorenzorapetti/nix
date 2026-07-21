{den, ...}: {
  den.aspects.networking.networkmanager = {
    includes = [
      den.aspects.networking.firewall
    ];

    nixos = {
      networking.networkmanager.enable = true;
      networking.dhcpcd.enable = false;
      services.resolved.enable = true;

      users.groups = {
        networkmanager = {};
      };
    };
  };
}
