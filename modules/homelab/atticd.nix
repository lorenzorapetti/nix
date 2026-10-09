{
  den.aspects.atticd = {
    traefik.atticd = {
      rule = "Host(`cache.home.lorenzolab.com`)";
      url = "http://127.0.0.1:8005";
    };

    nixos = {config, ...}: {
      sops.secrets.atticd-env = {
        sopsFile = ../secrets/atticd.env;
        format = "dotenv";
        key = "";
      };

      services.atticd = {
        enable = true;
        environmentFile = config.sops.secrets.atticd-env.path;

        settings = {
          listen = "127.0.0.1:8005";
          api-endpoint = "https://cache.home.lorenzolab.com/";

          jwt = {};

          chunking = {
            nar-size-threshold = 64 * 1024;
            min-size = 16 * 1024;
            avg-size = 64 * 1024;
            max-size = 256 * 1024;
          };

          # Lower than the default (8) to keep compression cheap on this host.
          compression = {
            type = "zstd";
            level = 3;
          };

          garbage-collection.default-retention-period = "6 months";
        };
      };

      # The host only has 4 cores and 16GB of RAM shared with the other
      # homelab services, so keep the cache from starving them.
      systemd.services.atticd = {
        environment.TOKIO_WORKER_THREADS = "2";
        serviceConfig = {
          CPUQuota = "200%";
          CPUWeight = 50;
          IOWeight = 50;
          MemoryHigh = "3G";
          MemoryMax = "4G";
        };
      };
    };
  };
}
