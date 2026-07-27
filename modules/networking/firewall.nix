{
  den.aspects.networking.firewall = {
    nixos = {
      firewall,
      lib,
      ...
    }: {
      networking.firewall = {
        enable = true;
        allowedTCPPorts = lib.concatMap (f: f.ports.tcp or []) firewall;
        allowedUDPPorts = lib.concatMap (f: f.ports.udp or []) firewall;
      };
    };
  };
}
