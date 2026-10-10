{
  perSystem = {
    pkgs,
    system,
    lib,
    ...
  }: let
    version = "0.4.0";

    # Prebuilt AppImages published with every GridCraft release. GridCraft is
    # not in nixpkgs, so wrap the release artifact. Bump `version` and both
    # hashes together:
    #   nix store prefetch-file --hash-type sha256 <url>
    sources = {
      x86_64-linux = {
        url = "https://github.com/storytold/gridcraft/releases/download/v${version}/gridcraft-${version}-linux-x86_64.AppImage";
        hash = "sha256-OPPp39gMA0+F9bOZMlIkuifYnWL0BFnaVIVgtQAoVN8=";
      };
      aarch64-linux = {
        url = "https://github.com/storytold/gridcraft/releases/download/v${version}/gridcraft-${version}-linux-aarch64.AppImage";
        hash = "sha256-17nGQmCt43LOM8kTkDt2l1w8iGdlAVOXf5nMMein61U=";
      };
    };

    pname = "gridcraft";
    appId = "ai.storyteller.gridcraft";
    src = pkgs.fetchurl sources.${system};
    appimageContents = pkgs.appimageTools.extract {inherit pname version src;};
  in
    lib.optionalAttrs (sources ? ${system}) {
      packages.gridcraft = pkgs.appimageTools.wrapType2 {
        inherit pname version src;

        # Ship the .desktop entry and icon set the AppImage carries. The entry
        # already uses `Exec=gridcraft %F`, which matches the wrapped binary.
        extraInstallCommands = ''
          install -Dm444 ${appimageContents}/${appId}.desktop -t $out/share/applications
          mkdir -p $out/share/icons
          cp -r ${appimageContents}/usr/share/icons/hicolor $out/share/icons/
        '';

        meta = {
          description = "Open-source, clean-room spreadsheet (Microsoft Excel-style) built in Rust";
          homepage = "https://github.com/storytold/gridcraft";
          downloadPage = "https://github.com/storytold/gridcraft/releases";
          changelog = "https://github.com/storytold/gridcraft/releases/tag/v${version}";
          license = lib.licenses.asl20;
          sourceProvenance = [lib.sourceTypes.binaryNativeCode];
          platforms = builtins.attrNames sources;
          mainProgram = pname;
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
