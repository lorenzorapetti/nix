{den, ...}: {
  den.aspects.docker = {
    includes = [
      (den.batteries.extra-groups "docker")
    ];

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
