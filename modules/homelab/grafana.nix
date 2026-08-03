{
  den.aspects.grafana = {
    traefik.grafana = {
      rule = "Host(`grafana.home.lorenzolab.com`)";
      url = "http://127.0.0.1:8003";
    };

    nixos = {config, ...}: {
      sops.secrets.grafana_admin_password.owner = "grafana";
      sops.secrets.grafana_secret_key.owner = "grafana";

      services.grafana = {
        enable = true;
        settings = {
          server = {
            http_addr = "127.0.0.1";
            http_port = 8003;
          };
          security = {
            admin_password = "$__file{${config.sops.secrets.grafana_admin_password.path}}";
            secret_key = "$__file{${config.sops.secrets.grafana_secret_key.path}}";
          };
        };
        provision.datasources.settings = {
          apiVersion = 1;
          datasources = [
            {
              name = "Loki";
              type = "loki";
              access = "proxy";
              url = "http://127.0.0.1:8004";
              isDefault = true;
            }
          ];
        };
      };
    };
  };
}
