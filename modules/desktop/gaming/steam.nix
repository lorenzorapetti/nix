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

      # Wine/Proton's in-kernel NT sync primitives; the CachyOS kernel ships
      # it as a module but leaves it unloaded, so /dev/ntsync is missing and
      # Proton falls back to esync/fsync.
      boot.kernelModules = ["ntsync"];

      environment.sessionVariables = {
        PROTON_ENABLE_WAYLAND = "1";
        # Mesa's default 1G cache evicts compiled shaders across games,
        # causing recompile stutter.
        MESA_SHADER_CACHE_MAX_SIZE = "16G";
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
