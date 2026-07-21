{lib, ...}: {
  den.aspects.base = {
    homeManager = {mimeApps ? [], ...}: let
      mimes = lib.listToAttrs (lib.flatten (lib.map (entry:
        lib.map (mime: {
          name = mime;
          value = entry.app;
        })
        entry.mimes)
      mimeApps));
    in {
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
          associations.added = mimes;
          defaultApplications = mimes;
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
