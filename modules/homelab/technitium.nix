{
  den.aspects.technitium = {
    traefik.technitium = {
      rule = "Host(`dns.home.lorenzorapetti.com`)";
      url = "http://127.0.0.1:5380";
    };

    nixos = {
      services.technitium-dns-server = {
        enable = true;
      };
    };

    firewall = {
      ports.udp = [53];
    };
  };
}
