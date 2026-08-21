{inputs, ...}: {
  den.aspects.development.rust = {
    nixos = {
      pkgs,
      lib,
      rustTargets,
      ...
    }: {
      nixpkgs.overlays = [
        inputs.rust-overlay.overlays.default
      ];

      environment.systemPackages = with pkgs; [
        (rust-bin.stable.latest.default.override {
          extensions = ["llvm-tools"];
          targets = lib.unique (lib.concatMap (t: t.targets or []) rustTargets);
        })
        cargo-binutils
        cargo-generate
        rust-analyzer
      ];
    };
  };
}
