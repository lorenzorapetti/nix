{inputs, ...}: {
  den.aspects.desktop.gaming = {
    nixos = {
      inputs',
      pkgs,
      ...
    }: {
      imports = [
        inputs.nix-gaming-edge.nixosModules.default
      ];

      nixpkgs.overlays = [
        inputs.nix-gaming-edge.overlays.default
        inputs.nix-gaming-edge.overlays.proton-cachyos
      ];

      programs.steam = {
        enable = true;
        extraCompatPackages = [
          pkgs.proton-ge-bin
          pkgs.proton-cachyos
        ];
      };

      hardware.graphics.enable = true;
      hardware.graphics.enable32Bit = true;
    };
  };
}
