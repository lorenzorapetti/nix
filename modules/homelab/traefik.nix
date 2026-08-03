{
  den.aspects.traefik = {
    nixos = {
      config,
      traefik,
      lib,
      ...
    }: let
      routes = lib.foldl' lib.recursiveUpdate {} traefik;
    in {
      sops.secrets.cloudflare_api_token.owner = "traefik";

      sops.templates."traefik-env".content = ''
        CLOUDFLARE_DNS_API_TOKEN=${config.sops.placeholder.cloudflare_api_token}
      '';

      systemd.services.traefik.serviceConfig.EnvironmentFile = [
        config.sops.templates."traefik-env".path
      ];

      # Alloy runs as its own user; traefik's dataDir defaults to mode 700,
      # so it needs both group membership and a loosened directory mode to
      # tail traefik.log/access.log from there.
      users.users.traefik.homeMode = "750";
      systemd.services.alloy.serviceConfig.SupplementaryGroups = ["traefik"];

      services.traefik = {
        enable = true;
        dataDir = "/var/lib/traefik";

        staticConfigOptions = {
          global = {
            checkNewVersion = false;
            sendAnonymousUsage = false;
          };

          log = {
            level = "DEBUG";
            filePath = "/var/lib/traefik/traefik.log";
            format = "json";
          };

          accessLog = {
            filePath = "/var/lib/traefik/access.log";
            format = "json";
          };

          api = {
            dashboard = true;
            insecure = true;
            disableDashboardAd = true;
          };

          entryPoints = {
            web = {
              address = ":80";
              http.redirections.entryPoint = {
                to = "websecure";
                scheme = "https";
              };
            };

            websecure = {
              address = ":443";
              http.tls.certResolver = "cloudflare";
            };
          };

          certificatesResolvers.cloudflare.acme = {
            email = "info@lorenzorapetti.com";
            storage = "/var/lib/traefik/acme.json";
            keyType = "EC256";
            dnsChallenge = {
              provider = "cloudflare";
              resolvers = [
                "1.1.1.1:53"
                "8.8.8.8:53"
              ];
            };
          };
        };

        dynamicConfigOptions.http = {
          routers =
            lib.mapAttrs (name: route: {
              entryPoints = ["web" "websecure"];
              rule = route.rule;
              service = name;
            })
            routes
            // {
              traefik = {
                entryPoints = ["web" "websecure"];
                service = "api@internal";
                rule = "Host(`traefik.home.lorenzolab.com`)";
              };
            };

          services =
            lib.mapAttrs (name: route: {
              loadBalancer.servers = [{url = route.url;}];
            })
            routes;
        };
      };
    };

    firewall = {
      ports.tcp = [80 443];
    };

    logging.alloy = ''
      local.file_match "traefik_logs" {
        path_targets = [
          {__path__ = "/var/lib/traefik/traefik.log", job = "traefik", log_type = "traefik"},
          {__path__ = "/var/lib/traefik/access.log", job = "traefik", log_type = "access"},
        ]
      }

      loki.source.file "traefik" {
        targets    = local.file_match.traefik_logs.targets
        forward_to = [loki.write.default.receiver]
      }
    '';

    traefik = {
      jetkvm = {
        rule = "Host(`jetkvm.home.lorenzolab.com`)";
        url = "http://10.0.0.86";
      };

      pikvm = {
        rule = "Host(`pikvm.home.lorenzolab.com`)";
        url = "http://10.0.0.70";
      };
    };
  };
}
