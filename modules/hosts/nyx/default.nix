{den, ...}: {
  # Nyx host with the server admin user.
  den.hosts.x86_64-linux.nyx.users.ops = {};

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
        atticd
      ]
      ++ [
        (den.batteries.wake-on-lan "enp2s0")
      ];

    nixos = {
      config,
      lib,
      ...
    }: {
      hardware.facter.reportPath = ./facter.json;

      # ops has no password, so sudo can't ask for one.
      security.sudo.wheelNeedsPassword = false;

      sops.secrets.nyx_tailscale_key = {};
      services.tailscale.authKeyFile = config.sops.secrets.nyx_tailscale_key.path;

      # Answer mDNS queries for nyx.local (avahi only resolves by default).
      services.avahi.settings.publish = {
        disable-publishing = false;
        publish-addresses = true;
      };

      nix = {
        settings = {
          max-jobs = 2;
          cores = 2;
          # Deploys log in as root, and a trusted user can get root without sudo.
          trusted-users = lib.mkForce ["root"];
        };

        daemonCPUSchedPolicy = "batch";
        daemonIOSchedClass = "idle";
      };
    };
  };
}
