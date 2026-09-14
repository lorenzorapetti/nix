{inputs, ...}: {
  den.aspects.desktop.noctalia-greeter = {
    nixos = {
      imports = [
        inputs.noctalia-greeter.nixosModules.default
      ];

      services.displayManager.noctalia-greeter = {
        enable = true;
      };
    };
  };
}
