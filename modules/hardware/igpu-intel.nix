{inputs, ...}: {
  den.aspects.hardware.igpu-intel = {
    nixos = {
      imports = [
        inputs.nixos-hardware.nixosModules.common-gpu-intel
      ];
    };
  };
}
