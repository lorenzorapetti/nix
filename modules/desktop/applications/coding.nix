{
  perSystem = {
    pkgs,
    system,
    lib,
    ...
  }: let
    version = "1.4.207";

    # Prebuilt AppImages published with every Orca release. Orca is not in
    # nixpkgs and has no upstream flake, and a from-source build would mean a
    # bespoke pnpm + Electron + native-module derivation, so wrap the release
    # artifact instead. Bump `version` and both hashes together:
    #   nix store prefetch-file --hash-type sha256 <url>
    sources = {
      x86_64-linux = {
        url = "https://github.com/stablyai/orca/releases/download/v${version}/orca-linux.AppImage";
        hash = "sha256-QRIsSbuWA6pr4mEU1EHXydp8o4luhiiCS2azspONuss=";
      };
      aarch64-linux = {
        url = "https://github.com/stablyai/orca/releases/download/v${version}/orca-linux-arm64.AppImage";
        hash = "sha256-UQ0RcEVMqmsYN+FAG7ba3QUEnL8VNIjdaPeUaBbgeag=";
      };
    };

    # Upstream ships the Linux binary and desktop entry as `orca-ide`, since
    # plain `orca` is the GNOME screen reader.
    pname = "orca-ide";
    src = pkgs.fetchurl sources.${system};
    appimageContents = pkgs.appimageTools.extractType2 {inherit pname version src;};
  in
    lib.optionalAttrs (sources ? ${system}) {
      packages.orca-ide = pkgs.appimageTools.wrapType2 {
        inherit pname version src;

        # Ship the .desktop entry and icon set the AppImage carries, pointing
        # Exec at the wrapped binary instead of the bundled AppRun.
        extraInstallCommands = ''
          install -Dm444 ${appimageContents}/${pname}.desktop -t $out/share/applications
          substituteInPlace $out/share/applications/${pname}.desktop \
            --replace-fail 'Exec=AppRun' 'Exec=${pname}'
          for size in 16 24 32 48 64 128 256 512; do
            install -Dm444 \
              "${appimageContents}/usr/share/icons/hicolor/''${size}x''${size}/apps/${pname}.png" \
              "$out/share/icons/hicolor/''${size}x''${size}/apps/${pname}.png"
          done
        '';

        meta = {
          description = "Next-gen IDE for parallel agentic development";
          homepage = "https://github.com/stablyai/orca";
          downloadPage = "https://github.com/stablyai/orca/releases";
          changelog = "https://github.com/stablyai/orca/releases/tag/v${version}";
          license = lib.licenses.mit;
          sourceProvenance = [lib.sourceTypes.binaryNativeCode];
          platforms = builtins.attrNames sources;
          mainProgram = pname;
        };
      };
    };

  den.aspects.desktop.coding = {
    homeManager = {self', ...}: {
      home.packages = [self'.packages.orca-ide];

      programs.zed-editor = {
        enable = true;
      };
    };
  };
}
