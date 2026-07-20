{
  den.aspects.desktop.gaming = {
    nixos = {pkgs, ...}: {
      services.ananicy = {
        enable = true;
        package = pkgs.ananicy-cpp;
        rulesProvider = pkgs.ananicy-rules-cachyos;
      };

      fileSystems."/sys/kernel/tracing" = {
        device = "tracefs";
        fsType = "tracefs";
      };
    };
  };
}
