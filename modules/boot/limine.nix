{
  den.aspects.boot.limine = {
    nixos = {
      boot.loader.limine = {
        enable = true;
        maxGenerations = 5;
      };

      boot.loader.efi.canTouchEfiVariables = true;
    };
  };
}
