{
  perSystem = {
    pkgs,
    system,
    lib,
    ...
  }: {
    packages = import ../../../_lib/appimage.nix {inherit pkgs lib system;} rec {
      pname = "gridcraft";
      version = "0.5.0";
      appId = "ai.storyteller.gridcraft";

      sources = {
        x86_64-linux = {
          url = "https://github.com/storytold/gridcraft/releases/download/v${version}/gridcraft-${version}-linux-x86_64.AppImage";
          hash = "sha256-+XqC0PIdM4H7sZoK4JKNZcXNxAL6pekgCDEs5Jh0XOI=";
        };
        aarch64-linux = {
          url = "https://github.com/storytold/gridcraft/releases/download/v${version}/gridcraft-${version}-linux-aarch64.AppImage";
          hash = "sha256-Dh5r+rb1CvsDglmw0i4a7bOCAJkcrAkRkY2hk37/w/c=";
        };
      };

      meta = {
        description = "Open-source, clean-room spreadsheet (Microsoft Excel-style) built in Rust";
        homepage = "https://github.com/storytold/gridcraft";
        downloadPage = "https://github.com/storytold/gridcraft/releases";
        changelog = "https://github.com/storytold/gridcraft/releases/tag/v${version}";
        license = lib.licenses.asl20;
      };
    };
  };

  den.aspects.desktop.base-applications = {
    homeManager = {self', ...}: {
      home.packages = [self'.packages.gridcraft];
    };

    mimeApps = [
      {
        mimes = [
          "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
          "application/vnd.ms-excel.sheet.macroEnabled.12"
          "text/csv"
          "text/tab-separated-values"
        ];
        app = "ai.storyteller.gridcraft.desktop";
      }
    ];
  };
}
