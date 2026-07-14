{
  den.aspects.base = {
    homeManager = {
      xdg = {
        enable = true;
        mime.enable = true;
        autostart = {
          enable = true;
          readOnly = true;
          # Add your autostart desktop files here. Example:
          # "${pkgs.evolution}/share/applications/org.gnome.Evolution.desktop"
          entries = [];
        };

        mimeApps = {
          enable = true;
          # TODO: Add default mime apps
        };

        userDirs = {
          enable = true;
          createDirectories = true;
        };
      };

      home = {
        preferXdgDirectories = true;
      };
    };
  };
}
