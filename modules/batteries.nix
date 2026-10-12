{
  den.batteries.wake-on-lan = interface: {
    includes = [
      # `host` is unused but tells den to apply this in host context only.
      # deadnix: skip
      ({host, ...}: {
        nixos.networking.interfaces.${interface}.wakeOnLan.enable = true;
      })
    ];
  };
}
