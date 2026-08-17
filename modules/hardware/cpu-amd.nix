{inputs, ...}: {
  den.aspects.hardware.cpu-amd = {
    nixos = {
      imports = [
        inputs.nixos-hardware.nixosModules.common-cpu-amd
        inputs.nixos-hardware.nixosModules.common-cpu-amd-pstate
      ];

      boot.kernelModules = ["k10temp"];
    };
  };
}
