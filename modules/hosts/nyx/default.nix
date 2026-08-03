{den, ...}: {
  # Nyx host with user Lorenzo.
  den.hosts.x86_64-linux.nyx.users.lorenzo = {};

  den.aspects.nyx = {
    includes = with den.aspects;
      [
        base
        boot.kernel-latest
        hardware.cpu-intel
        hardware.igpu-intel
        hardware.firmware
        networking

        traefik
        technitium
        glance
        loki
        grafana
        alloy
      ]
      ++ [
        (den.batteries.wake-on-lan "enp2s0")
      ];

    nixos = {config, ...}: {
      hardware.facter.reportPath = ./facter.json;

      sops.secrets.nyx_tailscale_key = {};
      services.tailscale.authKeyFile = config.sops.secrets.nyx_tailscale_key.path;

      observability.lokiEndpoint = "http://nyx.local:8004/loki/api/v1/push";
    };
  };
}
