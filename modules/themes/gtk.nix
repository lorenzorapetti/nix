{den, lib, ...}: {
  den.aspects.theming.base = {host, ...}: {
    homeManager = {
      pkgs,
      osConfig,
      ...
    }: let
      iconTheme = {
        name = "Adwaita";
        package = pkgs.adwaita-icon-theme;
      };
    in {
      gtk = lib.mkIf (host.hasAspect den.aspects.desktop) {
        enable = true;
        colorScheme = "dark";

        iconTheme = iconTheme;
        font.name = osConfig.fonts.sans;

        gtk2 = {
          enable = true;
          iconTheme = iconTheme;
        };

        gtk3 = {
          enable = true;
          iconTheme = iconTheme;
        };

        gtk4.iconTheme = iconTheme;
      };
    };
  };
}
