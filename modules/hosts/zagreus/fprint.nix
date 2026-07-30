{inputs, ...}: {
  den.aspects.zagreus.nixos = {
    imports = [inputs.libfprint-cs9711.nixosModules.default];

    hardware.fingerprint.cs9711 = {
      enable = true;
      enableFprintd = true;
    };
  };
}
