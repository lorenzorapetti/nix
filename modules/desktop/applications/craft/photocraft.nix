{
  perSystem = {
    pkgs,
    system,
    lib,
    ...
  }: let
    version = "0.6.0";

    # Prebuilt AppImages published with every PhotoCraft release. PhotoCraft
    # is not in nixpkgs, so wrap the release artifact. Bump `version` and both
    # hashes together:
    #   nix store prefetch-file --hash-type sha256 <url>
    sources = {
      x86_64-linux = {
        url = "https://github.com/storytold/photocraft/releases/download/v${version}/photocraft-${version}-linux-x86_64.AppImage";
        hash = "sha256-Y1+TiT+Unb8Xorwg4cKFqO/byIWchErS+6ro5wCfZ9Y=";
      };
      aarch64-linux = {
        url = "https://github.com/storytold/photocraft/releases/download/v${version}/photocraft-${version}-linux-aarch64.AppImage";
        hash = "sha256-1YgB51b+jjsWWWgA1t5J6Hb35lP45obEyUiD4mCDAVQ=";
      };
    };

    pname = "photocraft";
    appId = "ai.storyteller.photocraft";
    src = pkgs.fetchurl sources.${system};
    appimageContents = pkgs.appimageTools.extract {inherit pname version src;};
  in
    lib.optionalAttrs (sources ? ${system}) {
      packages.photocraft = pkgs.appimageTools.wrapType2 {
        inherit pname version src;

        # Ship the .desktop entry and icon set the AppImage carries. The entry
        # already uses `Exec=photocraft %F`, which matches the wrapped binary.
        extraInstallCommands = ''
          install -Dm444 ${appimageContents}/${appId}.desktop -t $out/share/applications
          mkdir -p $out/share/icons
          cp -r ${appimageContents}/usr/share/icons/hicolor $out/share/icons/
        '';

        meta = {
          description = "Open-source, clean-room reimplementation of Adobe Photoshop built in Rust";
          homepage = "https://github.com/storytold/photocraft";
          downloadPage = "https://github.com/storytold/photocraft/releases";
          changelog = "https://github.com/storytold/photocraft/releases/tag/v${version}";
          license = lib.licenses.asl20;
          sourceProvenance = [lib.sourceTypes.binaryNativeCode];
          platforms = builtins.attrNames sources;
          mainProgram = pname;
        };
      };
    };

  den.aspects.desktop.base-applications = {
    homeManager = {self', ...}: {
      home.packages = [self'.packages.photocraft];
    };

    mimeApps = [
      {
        # Upstream's .desktop also claims common image formats (png, jpeg,
        # webp, ...); leave those to imv and only take the editor formats.
        mimes = [
          "application/x-photocraft"
          "image/x-paintnet"
          "image/vnd.adobe.photoshop"
          "image/x-psd"
          "image/x-psb"
        ];
        app = "ai.storyteller.photocraft.desktop";
      }
    ];
  };
}
