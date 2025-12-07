{pkgs, ...}: {
  home.packages = with pkgs; [
    magnetic-catppuccin-gtk
  ];

  catppuccin = {
    accent = "lavender";
    flavor = "mocha";
    gtk = {
      icon = {
        enable = true;
      };
    };
    kvantum.enable = true;
  };

  dconf.settings."org/gnome/desktop/interface" = {
    color-scheme = "prefer-dark";
  };

  gtk = {
    enable = true;
    theme = {
      package = pkgs.magnetic-catppuccin-gtk;
      name = "Catppuccin-GTK-Dark";
    };
    gtk2.extraConfig = "gtk-application-prefer-dark-theme = true";
    gtk3.extraConfig.gtk-application-prefer-dark-theme = true;
  };

  qt = {
    enable = true;
    platformTheme.name = "kvantum";
    style.name = "kvantum";
  };
}
