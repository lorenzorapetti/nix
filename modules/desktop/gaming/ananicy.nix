{
  den.aspects.desktop.gaming = {
    nixos = {pkgs, ...}: {
      # TODO: Reenable this when https://github.com/NixOS/nixpkgs/pull/552211 gets merged.
      #
      # services.ananicy = {
      #   enable = true;
      #   package = pkgs.ananicy-cpp;
      #   rulesProvider = pkgs.ananicy-rules-cachyos;
      # };

      fileSystems."/sys/kernel/tracing" = {
        device = "tracefs";
        fsType = "tracefs";
      };
    };
  };
}
