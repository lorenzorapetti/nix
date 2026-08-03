{
  den.aspects.technitium = {
    traefik.technitium = {
      rule = "Host(`dns.home.lorenzolab.com`)";
      url = "http://127.0.0.1:5380";
    };

    nixos = {lib, ...}: {
      services.technitium-dns-server = {
        enable = true;
      };

      # DynamicUser stores StateDirectory/LogsDirectory under
      # /var/{lib,log}/private/<name>, which is root:root mode 0700 — no
      # other user can traverse into it no matter what the target directory's
      # own permissions are. Switch to a static user/group (same pattern as
      # traefik) so Alloy can actually read the logs via group membership.
      #
      # NOTE: this moves the state directory too. Existing DNS zone data
      # under /var/lib/private/technitium-dns-server must be migrated to
      # /var/lib/technitium-dns-server before switching, or the server will
      # start fresh/empty. See chat for the exact migration commands.
      systemd.services.technitium-dns-server.serviceConfig = {
        DynamicUser = lib.mkForce false;
        User = "technitium";
        Group = "technitium";
      };

      users.users.technitium = {
        isSystemUser = true;
        group = "technitium";
      };
      users.groups.technitium = {};

      systemd.services.alloy.serviceConfig.SupplementaryGroups = ["technitium"];
    };

    firewall = {
      ports.udp = [53];
    };

    logging.alloy = ''
      local.file_match "technitium_logs" {
        path_targets = [
          {__path__ = "/var/log/technitium/dns/*.log", job = "technitium"},
        ]
      }

      loki.source.file "technitium" {
        targets    = local.file_match.technitium_logs.targets
        forward_to = [loki.write.default.receiver]
      }
    '';
  };
}
