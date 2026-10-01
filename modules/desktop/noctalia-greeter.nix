{
  den.aspects.desktop.noctalia-greeter = {
    nixos = {
      services.displayManager.noctalia-greeter = {
        enable = true;
      };
    };
  };
}
