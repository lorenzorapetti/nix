{inputs, ...}: {
  den.aspects.theming.catppuccin = {
    nixos = {
      imports = [
        inputs.catppuccin.nixosModules.catppuccin
      ];

      catppuccin = {
        autoEnable = false;
        flavor = "mocha";
        accent = "lavender";

        limine.enable = true;
      };
    };

    homeManager = {
      imports = [
        inputs.catppuccin.homeModules.catppuccin
      ];
    };
  };
}
