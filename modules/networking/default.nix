{den, ...}: {
  den.aspects.networking = {
    includes = with den.aspects; [networking.networkmanager networking.firewall networking.tailscale];

    nixos = {pkgs, ...}: {
      systemd.network.wait-online.enable = false;
      boot.initrd.systemd.network.wait-online.enable = false;

      services.avahi = {
        enable = true;
        nssmdns4 = true;
        openFirewall = true;
      };

      environment.systemPackages = with pkgs; [
        cifs-utils
      ];
    };
  };
}
