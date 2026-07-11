{inputs, ...}: {
  den.aspects.theming.catppuccin = {
    nixos = {
      imports = [
        inputs.catppuccin.nixosModules.catppuccin
      ];

      catppuccin = {
        enable = true;
        autoEnable = false;
        flavor = "mocha";
        accent = "lavender";

        limine.enable = true;
        tty.enable = true;
      };
    };

    homeManager = {
      imports = [
        inputs.catppuccin.homeModules.catppuccin
      ];
    };
  };
}
