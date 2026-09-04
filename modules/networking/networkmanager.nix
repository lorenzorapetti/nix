{den, ...}: {
  den.aspects.networking.networkmanager = {
    includes = [
      den.aspects.networking.firewall
    ];

    nixos = {
      networking.networkmanager.enable = true;
      networking.dhcpcd.enable = false;
      services.resolved.enable = true;

      # Keep the global level at the default WARN, but log the DHCP/IP address
      # negotiation. At WARN, NM reports "Activation: failed" without a word about
      # the DHCP transaction, which makes a failure to get a lease undebuggable.
      networking.networkmanager.settings.logging.domains = "DHCP4:INFO,DHCP6:INFO,IP4:INFO,IP6:INFO";

      users.groups = {
        networkmanager = {};
      };
    };
  };
}
