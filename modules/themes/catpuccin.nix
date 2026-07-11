{inputs, ...}: let
  accent = "lavender";
  flavor = "mocha";
in {
  den.aspects.theming.catppuccin = {
    nixos = {
      imports = [
        inputs.catppuccin.nixosModule.catppuccin
      ];

      catppuccin = {
        limine = {
          enable = true;
          accent = accent;
          flavor = flavor;
        };
      };
    };

    homeManager = {
      imports = [
        inputs.catppuccin.homeModules.catppuccin
      ];
    };
  };
}
