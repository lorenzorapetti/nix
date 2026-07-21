{
  den.aspects.desktop.bambu-studio = {
    nixos = {pkgs, ...}: {
      environment.systemPackages = with pkgs; [
        bambu-studio
      ];
    };
  };
}
