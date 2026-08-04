{inputs, ...}: {
  den.aspects.desktop.face-unlock = {
    nixos = {
      imports = [inputs.gaze.nixosModules.default];

      services.gaze = {
        enable = true;
        mutableConfig = false;
        settings = {
          security.level = "low";
        };
      };
    };
  };
}
