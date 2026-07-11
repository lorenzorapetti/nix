{den, ...}: {
  den.aspects.networking.networkmanager = {
    includes = [
      den.aspects.networking.firewall
    ];

    nixos = {
      networking.networkmanager.enable = true;
    };
  };
}
