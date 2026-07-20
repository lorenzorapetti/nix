{inputs, ...}: {
  den.aspects.hardware.igpu-intel = {
    nixos = {pkgs, ...}: {
      imports = [
        inputs.nixos-hardware.nixosModules.common-gpu-intel
      ];
    };
  };
}
