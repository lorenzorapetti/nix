{
  perSystem = {
    pkgs,
    system,
    lib,
    ...
  }: {
    packages = import ../../../_lib/appimage.nix {inherit pkgs lib system;} rec {
      pname = "vectorcraft";
      version = "0.19.0";
      appId = "ai.storyteller.vectorcraft";

      sources = {
        x86_64-linux = {
          url = "https://github.com/storytold/vectorcraft/releases/download/v${version}/vectorcraft-${version}-linux-x86_64.AppImage";
          hash = "sha256-GGlVS6/UKNs7No+kBbirSIsl0yTTgOdyvAsRi7rLNMU=";
        };
        aarch64-linux = {
          url = "https://github.com/storytold/vectorcraft/releases/download/v${version}/vectorcraft-${version}-linux-aarch64.AppImage";
          hash = "sha256-W4NZOsH/rOlh3axqhYcGiC2+lq94UU+RyHpqLvkH4yc=";
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
