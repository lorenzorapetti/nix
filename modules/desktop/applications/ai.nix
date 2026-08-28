{inputs, ...}: {
  den.aspects.desktop.ai = {
    nixos = {pkgs, ...}: {
      nixpkgs.overlays = [
        inputs.claude-desktop.overlays.default
      ];

      environment.systemPackages = with pkgs; [
        claude-desktop
      ];
    };
  };
}
