{
  den.aspects.alloy = {
    logging.alloy = ''
      loki.source.journal "read" {
        forward_to = [loki.write.default.receiver]
        labels = {
          job  = "systemd-journal",
          host = constants.hostname,
        }
      }

      loki.source.journal "alloy" {
        forward_to = [loki.write.default.receiver]
        matches    = "_SYSTEMD_UNIT=alloy.service"
        labels = {
          job  = "alloy",
          host = constants.hostname,
        }
      }
    '';

    nixos = {
      config,
      lib,
      logging,
      ...
    }: {
      options.observability.lokiEndpoint = lib.mkOption {
        type = lib.types.str;
        description = "Loki push endpoint URL this host's Alloy instance pushes logs to.";
      };

      config = {
        environment.etc."alloy/config.alloy".text =
          ''
            loki.write "default" {
              endpoint {
                url = "${config.observability.lokiEndpoint}"
              }
            }
          ''
          + lib.concatMapStringsSep "\n\n" (l: l.alloy) logging;

        services.alloy.enable = true;
      };
    };
  };
}
