{
  perSystem = {
    pkgs,
    system,
    lib,
    ...
  }: {
    packages = import ../../../_lib/appimage.nix {inherit pkgs lib system;} rec {
      pname = "vectorcraft";
      version = "0.8.0";
      appId = "ai.storyteller.vectorcraft";

      sources = {
        x86_64-linux = {
          url = "https://github.com/storytold/vectorcraft/releases/download/v${version}/vectorcraft-${version}-linux-x86_64.AppImage";
          hash = "sha256-ix62bdrHfDnACl9ZF1nY56SVR6bi4QdwbnQYuSjiNqo=";
        };
        aarch64-linux = {
          url = "https://github.com/storytold/vectorcraft/releases/download/v${version}/vectorcraft-${version}-linux-aarch64.AppImage";
          hash = "sha256-MMVrYHzJx/h3lyTcntH13mTcZ19Jkl4g3y9t/jMArd4=";
        };
      };

      meta = {
        description = "Open-source, clean-room reimplementation of Adobe Illustrator built in Rust";
        homepage = "https://github.com/storytold/vectorcraft";
        downloadPage = "https://github.com/storytold/vectorcraft/releases";
        changelog = "https://github.com/storytold/vectorcraft/releases/tag/v${version}";
        license = lib.licenses.asl20;
      };
    };
  };

  den.aspects.desktop.base-applications = {
    homeManager = {self', ...}: {
      home.packages = [self'.packages.vectorcraft];
    };

    mimeApps = [
      {
        # Upstream's .desktop also claims application/pdf; PdfCraft keeps that.
        mimes = [
          "image/svg+xml"
          "image/svg+xml-compressed"
          "application/illustrator" # PDF-compatible .ai
          "image/x-eps"
        ];
        app = "ai.storyteller.vectorcraft.desktop";
      }
    ];
  };
}
