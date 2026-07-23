{
  den.aspects.boot.kernel-latest.nixos = {pkgs, ...}: {
    boot.kernelPackages = pkgs.linuxPackages_latest;
  };
}
