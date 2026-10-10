{
  perSystem = {
    pkgs,
    system,
    lib,
    ...
  }: let
    version = "0.5.0";

    # Prebuilt AppImages published with every PdfCraft release. PdfCraft is not
    # in nixpkgs, so wrap the release artifact. Bump `version` and both hashes
    # together:
    #   nix store prefetch-file --hash-type sha256 <url>
    sources = {
      x86_64-linux = {
        url = "https://github.com/storytold/pdfcraft/releases/download/v${version}/pdfcraft-${version}-linux-x86_64.AppImage";
        hash = "sha256-cjwWcw69cs/xK0DmSO2TWQDzrLWQsi0DbirxOijOb0U=";
      };
      aarch64-linux = {
        url = "https://github.com/storytold/pdfcraft/releases/download/v${version}/pdfcraft-${version}-linux-aarch64.AppImage";
        hash = "sha256-7+Cjo7sDypZlcR0vLuy26rfnzr7c9jL/g1FTH0bQb1E=";
      };
    };

    pname = "pdfcraft";
    appId = "ai.storyteller.pdfcraft";
    src = pkgs.fetchurl sources.${system};
    appimageContents = pkgs.appimageTools.extract {inherit pname version src;};
  in
    lib.optionalAttrs (sources ? ${system}) {
      packages.pdfcraft = pkgs.appimageTools.wrapType2 {
        inherit pname version src;

        # Ship the .desktop entry and icon set the AppImage carries. The entry
        # already uses `Exec=pdfcraft`, which matches the wrapped binary.
        extraInstallCommands = ''
          install -Dm444 ${appimageContents}/${appId}.desktop -t $out/share/applications
          mkdir -p $out/share/icons
          cp -r ${appimageContents}/usr/share/icons/hicolor $out/share/icons/
        '';

        meta = {
          description = "Open-source, clean-room reimplementation of Adobe Acrobat built in Rust";
          homepage = "https://github.com/storytold/pdfcraft";
          downloadPage = "https://github.com/storytold/pdfcraft/releases";
          changelog = "https://github.com/storytold/pdfcraft/releases/tag/v${version}";
          license = lib.licenses.asl20;
          sourceProvenance = [lib.sourceTypes.binaryNativeCode];
          platforms = builtins.attrNames sources;
          mainProgram = pname;
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
