{inputs, ...}: {
  den.aspects.boot.kernel-cachyos.nix = {pkgs, ...}: {
    nixpkgs.overlays = [
      inputs.nix-cachyos-kernel.overlays.pinned
    ];

    boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-bore;
  };
}
