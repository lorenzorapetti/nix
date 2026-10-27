{
  perSystem = {
    pkgs,
    system,
    lib,
    ...
  }: {
    packages = import ../../../_lib/appimage.nix {inherit pkgs lib system;} rec {
      pname = "vectorcraft";
      version = "0.17.0";
      appId = "ai.storyteller.vectorcraft";

      sources = {
        x86_64-linux = {
          url = "https://github.com/storytold/vectorcraft/releases/download/v${version}/vectorcraft-${version}-linux-x86_64.AppImage";
          hash = "sha256-5JhIh725gBlt6iQehoMeVGE8z9Q05Ot0t0mK2iu1SeM=";
        };
        aarch64-linux = {
          url = "https://github.com/storytold/vectorcraft/releases/download/v${version}/vectorcraft-${version}-linux-aarch64.AppImage";
          hash = "sha256-KX9723c5yQfUCgD+OlwIPhgzhxTl6IMzTZ/7n0XXcFI=";
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
