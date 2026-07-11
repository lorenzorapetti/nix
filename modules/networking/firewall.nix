{
  den.aspects.networking.firewall = {
    nixos = {
      firewall,
      lib,
      ...
    }: {
      networking.firewall.enable = true;

      networking.firewall.allowedTCPPorts = lib.concatMap (f: f.ports or []) firewall;
    };
  };
}
