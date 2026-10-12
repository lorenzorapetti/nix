{
  perSystem = {
    pkgs,
    system,
    lib,
    ...
  }: {
    packages = import ../../../_lib/appimage.nix {inherit pkgs lib system;} rec {
      pname = "wordcraft";
      version = "0.5.0";
      appId = "ai.storyteller.wordcraft";

      sources = {
        x86_64-linux = {
          url = "https://github.com/storytold/wordcraft/releases/download/v${version}/wordcraft-${version}-linux-x86_64.AppImage";
          hash = "sha256-lHfqkt2e3yq5dL3jJZWEWyc3snskx6QGWctdzieydVE=";
        };
        aarch64-linux = {
          url = "https://github.com/storytold/wordcraft/releases/download/v${version}/wordcraft-${version}-linux-aarch64.AppImage";
          hash = "sha256-6LULic0RnkNsQjzvLP7/OFs16BtYSWiSBMJ+ttmBW7M=";
        };
      };

      meta = {
        description = "Open-source, clean-room reimplementation of Microsoft Word built in Rust";
        homepage = "https://github.com/storytold/wordcraft";
        downloadPage = "https://github.com/storytold/wordcraft/releases";
        changelog = "https://github.com/storytold/wordcraft/releases/tag/v${version}";
        license = lib.licenses.asl20;
      };
    };
  };

  den.aspects.desktop.base-applications = {
    homeManager = {self', ...}: {
      home.packages = [self'.packages.wordcraft];
    };

    mimeApps = [
      {
        # Upstream's .desktop also claims text/plain, text/html and
        # text/markdown; leave those to the editor/browser.
        mimes = [
          "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
          "application/msword" # Word 97-2003 .doc (import only)
          "application/vnd.oasis.opendocument.text"
          "application/rtf"
        ];
        app = "ai.storyteller.wordcraft.desktop";
      }
    ];
  };
}
