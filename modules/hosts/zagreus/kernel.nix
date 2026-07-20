{den, inputs, ...}: {
  den.aspects.zagreus = {
    includes = [
      den.aspects.boot.kernel-cachyos
    ];

    nixos = {pkgs, ...}: {
      nixpkgs.overlays = [
        inputs.nix-cachyos-kernel.overlays.pinned
      ];

      boot.kernelPackages = let
        kernel = pkgs.cachyosKernels.linux-cachyos-bore-lto-zen4.override {
          performanceGovernor = true;
          bbr3 = true;
        };

        helpers = pkgs.callPackage "${inputs.nix-cachyos-kernel.outPath}/helpers.nix" { };
      in helpers.kernelModuleLLVMOverride (pkgs.linuxKernel.packagesFor kernel);

      boot.kernelParams = [
        "nowatchdog"
        "threadirqs"
        "mitigations=off"
      ];
    };
  };
}
