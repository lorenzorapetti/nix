{inputs, ...}: {
  den.aspects.desktop.noctalia-greeter = {
    nixos = {
      imports = [
        inputs.noctalia-greeter.nixosModules.default
      ];

      programs.noctalia-greeter = {
        enable = true;
      };
    };
  };
}
