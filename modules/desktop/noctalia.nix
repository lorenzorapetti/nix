{
  inputs,
  den,
  ...
}: {
  den.aspects.desktop.noctalia = {
    includes = with den.aspects; [
      desktop.noctalia-greeter
    ];

    nixos = {
      imports = [
        inputs.noctalia.nixosModules.default
      ];

      programs.noctalia = {
        enable = true;
      };
    };

    homeManager = {
      imports = [
        inputs.noctalia.homeModules.default
      ];

      programs.noctalia = {
        enable = true;
        systemd.enable = true;

        settings = {
          shell = {
            polkit_agent = true;
          };
        };
      };
    };
  };
}
