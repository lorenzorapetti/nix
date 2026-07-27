{
  den.aspects.glance = {
    traefik.glance = {
      rule = "Host(`home.lorenzorapetti.com`)";
      url = "http://127.0.0.1:8001";
    };

    nixos = {
      services.glance = {
        enable = true;
        settings = {
          server.port = 8001;
        };
      };
    };
  };
}
