{den, ...}: {
  den.aspects.docker = {
    nixos = {
      virtualisation.docker = {
        enable = true;
        enableOnBoot = false;
      };
    };

    homeManager = {
      programs.lazydocker = {
        enable = true;
      };
    };
  };
}
