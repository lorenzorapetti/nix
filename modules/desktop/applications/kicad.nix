{
  den.aspects.desktop.kicad.nixos = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      kicad
    ];
  };
}
