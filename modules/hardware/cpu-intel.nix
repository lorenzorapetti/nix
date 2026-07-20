{inputs, ...}: {
  den.aspects.hardware.cpu-intel = {
    nixos = {
      imports = [
        inputs.nixos-hardware.nixosModules.common-cpu-intel
      ];
    };
  };
}
