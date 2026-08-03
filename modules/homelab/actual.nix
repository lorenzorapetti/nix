{
  den.aspects.actual = {
    traefik.actual = {
      rule = "Host(`actual.lorenzolab.com`)";
      url = "http://127.0.0.1:8002";
    };
  };
}
