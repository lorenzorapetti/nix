{
  # Services that are needed for window managers without a full desktop environment.
  den.aspects.desktop.wm = {
    nixos = {
      services.gnome.gnome-keyring.enable = true;
      services.udisks2 = {
        enable = true;
      };

      programs.seahorse.enable = true;
    };
  };
}
