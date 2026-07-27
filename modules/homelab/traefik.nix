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
                rule = "Host(`traefik.home.lorenzorapetti.com`)";
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
  };
}
