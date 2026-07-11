{
  den.aspects.boot.limine = {
    nixos = {
      boot.loader.limine = {
        enable = true;
      };

      boot.loader.efi.canTouchEfiVariables = true;
    };
  };
}
