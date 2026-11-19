{
  den.aspects.technitium = {
    traefik.technitium = {
      rule = "Host(`dns.home.lorenzolab.com`)";
      url = "http://127.0.0.1:5380";
    };

    nixos = {lib, ...}: {
      services.technitium-dns-server = {
        enable = true;
      };

      systemd.services.technitium-dns-server.serviceConfig = {
        DynamicUser = lib.mkForce false;
        User = "technitium";
        Group = "technitium";
      };

      users.users.technitium = {
        isSystemUser = true;
        group = "technitium";
      };
      users.groups.technitium = {};

      # resolved's stub listener holds TCP 127.0.0.53:53/127.0.0.54:53, so
      # Technitium's 0.0.0.0:53 TCP bind fails and IPv4 TCP DNS is refused
      # (UDP tolerates the overlap). Drop the stub and resolve the host's own
      # lookups through Technitium.
      services.resolved.settings.Resolve.DNSStubListener = false;
      networking.nameservers = ["127.0.0.1"];
    };

    firewall = {
      ports.tcp = [53];
      ports.udp = [53];
    };
  };
}
