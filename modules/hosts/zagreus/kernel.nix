{den, inputs, ...}: {
  den.aspects.zagreus = {
    includes = [
      den.aspects.boot.kernel-cachyos
    ];

    nixos = {pkgs, ...}: {
      kernel = pkgs.cachyosKernels.linuxPackages-cachyos-bore-lto-zen4.override = {
        performanceGovernor = true;
        bbr3 = true;
      };

      kernelPackages = pkgs.linuxKernel.packagesFor kernel;

      # For LTO kernels, helpers.kernelModuleLLVMOverride fixes compilation for some
      # out-of-tree modules in nixpkgs.
      kernelPackagesWithLTOFix = let
        # helpers.nix provides a few utilities for building kernel with LTO.
        # I haven't figured out a clean way to expose it in flakes.
        helpers = pkgs.callPackage "${inputs.nix-cachyos-kernel.outPath}/helpers.nix" {};
      in helpers.kernelModuleLLVMOverride (pkgs.linuxKernel.packagesFor kernel);
    };
  };
}
