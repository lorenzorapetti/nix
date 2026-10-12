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
            level = "INFO";
            filePath = "/var/lib/traefik/traefik.log";
            format = "json";
          };

          accessLog = {
            filePath = "/var/lib/traefik/access.log";
            format = "json";
          };

          api = {
            dashboard = true;
            insecure = false;
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
              # The default readTimeout (60s) kills large uploads, e.g. attic pushes.
              transport.respondingTimeouts.readTimeout = "0s";
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
              inherit (route) rule;
              service = name;
            })
            routes
            // {
              traefik = {
                entryPoints = ["web" "websecure"];
                service = "api@internal";
                rule = "Host(`traefik.home.lorenzolab.com`)";
                middlewares = ["local-only"];
              };
            };

          # The dashboard has no auth of its own; only serve it to the LAN and
          # the tailnet.
          middlewares.local-only.ipAllowList.sourceRange = [
            "127.0.0.1/32"
            "10.0.0.0/16"
            "100.64.0.0/10"
          ];

          services =
            lib.mapAttrs (_name: route: {
              loadBalancer.servers = [{inherit (route) url;}];
            })
            routes;
        };
      };
    };

    firewall = {
      ports.tcp = [80 443];
    };

    traefik = {
      jetkvm = {
        rule = "Host(`jetkvm.home.lorenzolab.com`)";
        url = "http://10.0.0.86";
      };

      pikvm = {
        rule = "Host(`pikvm.home.lorenzolab.com`)";
        url = "http://10.0.0.70";
      };

      jellyfin = {
        rule = "Host(`media.lorenzorapetti.com`)";
        url = "http://10.0.1.10:8096";
      };
    };
  };
}
