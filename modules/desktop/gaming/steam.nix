{inputs, ...}: {
  den.aspects.desktop.gaming = {
    nixos = {pkgs, ...}: {
      imports = [
        inputs.nix-gaming-edge.nixosModules.default
      ];

      nixpkgs.overlays = [
        inputs.nix-gaming-edge.overlays.default
        inputs.nix-gaming-edge.overlays.proton-cachyos
      ];

      environment.sessionVariables = {
        PROTON_ENABLE_WAYLAND = "1";
      };

      programs.steam = {
        enable = true;
        extraCompatPackages = [
          pkgs.proton-ge-bin
          pkgs.proton-cachyos
        ];
      };

      programs.gamescope = {
        enable = true;
      };

      hardware.graphics.enable = true;
      hardware.graphics.enable32Bit = true;
    };
  };
}
