{
  den.aspects.loki = {
    firewall.ports.tcp = [8004];

    logging.alloy = ''
      loki.source.journal "loki" {
        forward_to = [loki.write.default.receiver]
        matches    = "_SYSTEMD_UNIT=loki.service"
        labels = {
          job  = "loki",
          host = constants.hostname,
        }
      }
    '';

    nixos = {
      services.loki = {
        enable = true;
        dataDir = "/var/lib/loki";
        configuration = {
          auth_enabled = false;
          server.http_listen_port = 8004;
          common = {
            path_prefix = "/var/lib/loki";
            replication_factor = 1;
            storage.filesystem = {
              chunks_directory = "/var/lib/loki/chunks";
              rules_directory = "/var/lib/loki/rules";
            };
            ring.kvstore.store = "inmemory";
          };
          schema_config.configs = [
            {
              from = "2024-01-01";
              store = "tsdb";
              object_store = "filesystem";
              schema = "v13";
              index = {
                prefix = "index_";
                period = "24h";
              };
            }
          ];
        };
      };
    };
  };
}
