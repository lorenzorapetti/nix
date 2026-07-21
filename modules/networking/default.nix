{
  den.aspects.networking = {
    nixos = {pkgs, ...}: {
      networking.nftables.enable = true;
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
