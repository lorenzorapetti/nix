{
  perSystem = {
    pkgs,
    system,
    lib,
    ...
  }: {
    packages = import ../../../_lib/appimage.nix {inherit pkgs lib system;} rec {
      pname = "pdfcraft";
      version = "0.9.0";
      appId = "ai.storyteller.pdfcraft";

      sources = {
        x86_64-linux = {
          url = "https://github.com/storytold/pdfcraft/releases/download/v${version}/pdfcraft-${version}-linux-x86_64.AppImage";
          hash = "sha256-+FaMh5BtloRhBS8LVwl8C4S3Cze/ZJybUE2MHretDPo=";
        };
        aarch64-linux = {
          url = "https://github.com/storytold/pdfcraft/releases/download/v${version}/pdfcraft-${version}-linux-aarch64.AppImage";
          hash = "sha256-6vBd0cRYziB+nZn8116KPgyXE2wl++fpClC4bHZ7O7s=";
        };
      };

      meta = {
        description = "Open-source, clean-room reimplementation of Adobe Acrobat built in Rust";
        homepage = "https://github.com/storytold/pdfcraft";
        downloadPage = "https://github.com/storytold/pdfcraft/releases";
        changelog = "https://github.com/storytold/pdfcraft/releases/tag/v${version}";
        license = lib.licenses.asl20;
      };
    };
  };

  den.aspects.desktop.base-applications = {
    homeManager = {self', ...}: {
      home.packages = [self'.packages.pdfcraft];
    };

    mimeApps = [
      {
        mimes = [
          "application/pdf"
          "application/x-pdf"
          "application/vnd.pdf"
          "application/x-bzpdf"
        ];
        app = "ai.storyteller.pdfcraft.desktop";
      }
    ];
  };
}
