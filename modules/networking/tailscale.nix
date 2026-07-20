{
  den.aspects.networking.tailscale = {
    nixos = {config, ...}: {
      services.tailscale = {
        enable = true;
      };

      networking.firewall = {
        # Always allow traffic from your Tailscale network
        trustedInterfaces = [config.services.tailscale.interfaceName];
        # Allow the Tailscale UDP port through the firewall
        allowedUDPPorts = [config.services.tailscale.port];
      };

      systemd.services.tailscaled.serviceConfig.Environment = [
        "TS_DEBUG_FIREWALL_MODE=nftables"
      ];
    };
  };
}
