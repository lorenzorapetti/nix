{
  perSystem = {
    pkgs,
    system,
    lib,
    ...
  }: let
    version = "0.8.0";

    # Prebuilt AppImages published with every VectorCraft release. VectorCraft
    # is not in nixpkgs, so wrap the release artifact. Bump `version` and both
    # hashes together:
    #   nix store prefetch-file --hash-type sha256 <url>
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

    pname = "vectorcraft";
    appId = "ai.storyteller.vectorcraft";
    src = pkgs.fetchurl sources.${system};
    appimageContents = pkgs.appimageTools.extract {inherit pname version src;};
  in
    lib.optionalAttrs (sources ? ${system}) {
      packages.vectorcraft = pkgs.appimageTools.wrapType2 {
        inherit pname version src;

        # Ship the .desktop entry and icon set the AppImage carries. The entry
        # already uses `Exec=vectorcraft %F`, which matches the wrapped binary.
        extraInstallCommands = ''
          install -Dm444 ${appimageContents}/${appId}.desktop -t $out/share/applications
          mkdir -p $out/share/icons
          cp -r ${appimageContents}/usr/share/icons/hicolor $out/share/icons/
        '';

        meta = {
          description = "Open-source, clean-room reimplementation of Adobe Illustrator built in Rust";
          homepage = "https://github.com/storytold/vectorcraft";
          downloadPage = "https://github.com/storytold/vectorcraft/releases";
          changelog = "https://github.com/storytold/vectorcraft/releases/tag/v${version}";
          license = lib.licenses.asl20;
          sourceProvenance = [lib.sourceTypes.binaryNativeCode];
          platforms = builtins.attrNames sources;
          mainProgram = pname;
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
