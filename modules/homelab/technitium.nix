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
    };

    firewall = {
      ports.udp = [53];
    };
  };
}
