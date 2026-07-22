{
  den.batteries.wake-on-lan = interface: {
    includes = [
      ({host, ...}: {
        nixos.networking.interfaces.${interface}.wakeOnLan.enable = true;
      })
    ];
  };
}
