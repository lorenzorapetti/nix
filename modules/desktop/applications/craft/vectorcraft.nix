{
  perSystem = {
    pkgs,
    system,
    lib,
    ...
  }: {
    packages = import ../../../_lib/appimage.nix {inherit pkgs lib system;} rec {
      pname = "vectorcraft";
      version = "0.13.1";
      appId = "ai.storyteller.vectorcraft";

      sources = {
        x86_64-linux = {
          url = "https://github.com/storytold/vectorcraft/releases/download/v${version}/vectorcraft-${version}-linux-x86_64.AppImage";
          hash = "sha256-lUV7ubSLxjRBJMK/MqEGAGVIqllLG40djKR9UqMOV34=";
        };
        aarch64-linux = {
          url = "https://github.com/storytold/vectorcraft/releases/download/v${version}/vectorcraft-${version}-linux-aarch64.AppImage";
          hash = "sha256-xc+sH2fWJiwPWZsgc5huRdHg1LRQe3L2deMwj2N7Agw=";
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
