{
  perSystem = {
    pkgs,
    system,
    lib,
    ...
  }: let
    version = "0.4.0";

    # Prebuilt AppImages published with every WordCraft release. WordCraft is
    # not in nixpkgs, so wrap the release artifact. Bump `version` and both
    # hashes together:
    #   nix store prefetch-file --hash-type sha256 <url>
    sources = {
      x86_64-linux = {
        url = "https://github.com/storytold/wordcraft/releases/download/v${version}/wordcraft-${version}-linux-x86_64.AppImage";
        hash = "sha256-3R7dyscsQ1fg1m9F462fRsKEW129QviV0iHD7dhGLOk=";
      };
      aarch64-linux = {
        url = "https://github.com/storytold/wordcraft/releases/download/v${version}/wordcraft-${version}-linux-aarch64.AppImage";
        hash = "sha256-wMo3m1RwLdpWPZyU2YTtkCagc3MA1RuZRlfG88GOspE=";
      };
    };

    pname = "wordcraft";
    appId = "ai.storyteller.wordcraft";
    src = pkgs.fetchurl sources.${system};
    appimageContents = pkgs.appimageTools.extract {inherit pname version src;};
  in
    lib.optionalAttrs (sources ? ${system}) {
      packages.wordcraft = pkgs.appimageTools.wrapType2 {
        inherit pname version src;

        # Ship the .desktop entry and icon set the AppImage carries. The entry
        # already uses `Exec=wordcraft %F`, which matches the wrapped binary.
        extraInstallCommands = ''
          install -Dm444 ${appimageContents}/${appId}.desktop -t $out/share/applications
          mkdir -p $out/share/icons
          cp -r ${appimageContents}/usr/share/icons/hicolor $out/share/icons/
        '';

        meta = {
          description = "Open-source, clean-room reimplementation of Microsoft Word built in Rust";
          homepage = "https://github.com/storytold/wordcraft";
          downloadPage = "https://github.com/storytold/wordcraft/releases";
          changelog = "https://github.com/storytold/wordcraft/releases/tag/v${version}";
          license = lib.licenses.asl20;
          sourceProvenance = [lib.sourceTypes.binaryNativeCode];
          platforms = builtins.attrNames sources;
          mainProgram = pname;
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
