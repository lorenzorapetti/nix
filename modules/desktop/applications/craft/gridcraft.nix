{
  perSystem = {
    pkgs,
    system,
    lib,
    ...
  }: {
    packages = import ../../../_lib/appimage.nix {inherit pkgs lib system;} rec {
      pname = "gridcraft";
      version = "0.16.1";
      appId = "ai.storyteller.gridcraft";

      sources = {
        x86_64-linux = {
          url = "https://github.com/storytold/gridcraft/releases/download/v${version}/gridcraft-${version}-linux-x86_64.AppImage";
          hash = "sha256-l7atP75HHS3pTeqqfbMSYko53WPl7h679rOFY9Yqrlc=";
        };
        aarch64-linux = {
          url = "https://github.com/storytold/gridcraft/releases/download/v${version}/gridcraft-${version}-linux-aarch64.AppImage";
          hash = "sha256-OyQci6YIwDVSeAWAIFLtADUDrRFQFmjLfCgkrWGdN6I=";
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
