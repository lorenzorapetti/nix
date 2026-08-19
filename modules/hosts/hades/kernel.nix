{
  den,
  inputs,
  ...
}: {
  den.aspects.hades = {
    includes = [
      den.aspects.boot.kernel-cachyos
    ];

    nixos = {pkgs, ...}: {
      nixpkgs.overlays = [
        inputs.nix-cachyos-kernel.overlays.pinned
      ];

      boot.kernelPackages = let
        kernel = pkgs.cachyosKernels.linux-cachyos-bore-lto-x86_64-v3.override {
          bbr3 = true;
        };

        helpers = pkgs.callPackage "${inputs.nix-cachyos-kernel.outPath}/helpers.nix" {};
      in
        helpers.kernelModuleLLVMOverride (pkgs.linuxKernel.packagesFor kernel);

      boot.kernelParams = [
        "nowatchdog"
      ];
    };
  };
}
