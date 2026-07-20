{
  den,
  inputs,
  ...
}: {
  den.aspects.zagreus = {
    includes = [
      den.aspects.boot.kernel-cachyos
    ];

    nixos = {
      pkgs,
      config,
      lib,
      ...
    }: {
      nixpkgs.overlays = [
        inputs.nix-cachyos-kernel.overlays.pinned
      ];

      boot.kernelPackages = let
        kernel = pkgs.cachyosKernels.linux-cachyos-bore-lto-zen4.override {
          performanceGovernor = true;
          bbr3 = true;
        };

        helpers = pkgs.callPackage "${inputs.nix-cachyos-kernel.outPath}/helpers.nix" {};
      in
        helpers.kernelModuleLLVMOverride (pkgs.linuxKernel.packagesFor kernel);

      boot.kernelParams = [
        "nowatchdog"
        "threadirqs"
        "mitigations=off"
      ];

      # zenpower's Makefile just recurses into $KERNEL_BUILD without forwarding
      # LLVM=1/CC=clang, so kbuild falls back to its default `CC = gcc`, and gcc
      # doesn't exist in this clang-only kernel's build sandbox. Adding gcc to
      # environment.systemPackages doesn't help since it never reaches the build
      # sandbox; kernelModuleLLVMOverride doesn't help either since it only
      # patches a literal "gcc" string in each module's Makefile, and zenpower's
      # Makefile doesn't contain one. Force the kernel's LLVM make flags through
      # to zenpower's own build instead.
      boot.extraModulePackages = lib.mkForce [
        (config.boot.kernelPackages.zenpower.overrideAttrs (old: {
          makeFlags = old.makeFlags ++ config.boot.kernelPackages.kernelModuleMakeFlags;
        }))
      ];
    };
  };
}
