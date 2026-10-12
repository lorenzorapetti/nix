{
  perSystem = {
    pkgs,
    system,
    lib,
    ...
  }: {
    # Orca is not in nixpkgs and has no upstream flake, and a from-source build
    # would mean a bespoke pnpm + Electron + native-module derivation, so wrap
    # the release AppImage instead.
    packages = import ../../_lib/appimage.nix {inherit pkgs lib system;} rec {
      # Upstream ships the Linux binary and desktop entry as `orca-ide`, since
      # plain `orca` is the GNOME screen reader.
      pname = "orca-ide";
      version = "1.4.223";

      sources = {
        x86_64-linux = {
          url = "https://github.com/stablyai/orca/releases/download/v${version}/orca-linux.AppImage";
          hash = "sha256-Dhis/lwH7Rk6/2A/tja6H8WQeBEgOad5pUQ6jVNIPUs=";
        };
        aarch64-linux = {
          url = "https://github.com/stablyai/orca/releases/download/v${version}/orca-linux-arm64.AppImage";
          hash = "sha256-2n/S5dzTfyWCSA7c+gpLdILXxVXfWYvrrs0nhdTLD0A=";
        };
      };

      # Ship the .desktop entry and icon set the AppImage carries, pointing
      # Exec at the wrapped binary instead of the bundled AppRun.
      extraInstallCommands = appimageContents: ''
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
