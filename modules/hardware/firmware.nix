{
  den.aspects.hardware.firmware = {
    nixos = {
      services.fwupd = {
        enable = true;
      };
    };
  };
}
