{den, ...}: {
  den.aspects.desktop.hyprland = {
    includes = with den.aspects; [
      desktop
      desktop.base-applications
      desktop.noctalia
    ];

    nixos = {
      inputs',
      pkgs,
      ...
    }: {
      environment.systemPackages = with pkgs; [
        runapp
      ];

      programs.hyprland = {
        enable = true;
        withUWSM = true;

        package = inputs'.hyprland.packages.hyprland;
        portalPackage = inputs'.hyprland.packages.xdg-desktop-portal-hyprland;
      };
    };

    homeManager = {
      wayland.windowManager.hyprland = {
        enable = true;

        # set the Hyprland and XDPH packages to null to use the ones from the NixOS module
        package = null;
        portalPackage = null;
      };
    };
  };
}
