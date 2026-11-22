# DBDelve (https://github.com/ShayanAbbas1/dbdelve): a native multi-engine
# database client. Packaged from the prebuilt release tarball, laid out the way
# the tarball's own install.sh does it, but into the store instead of ~/.local.
#
# When bumping, update `version` and both tarball hashes.
{
  perSystem = {
    pkgs,
    lib,
    system,
    ...
  }: let
    version = "0.7.3";
    arches = {
      x86_64-linux = {
        arch = "x86_64";
        hash = "sha256-XFi72qGNGsAKXUAi5/S1E/TTvJBTkJfuiwUmCO3VPfI=";
      };
      aarch64-linux = {
        arch = "aarch64";
        hash = "sha256-aBKMMDw9Yoglp8TVgk2Jl9dZRFsmmGJdp+g+dQTXOGw=";
      };
    };
  in
    lib.optionalAttrs (arches ? ${system}) {
      packages.dbdelve = let
        inherit (arches.${system}) arch hash;
      in
        pkgs.stdenv.mkDerivation {
          pname = "dbdelve";
          inherit version;

          src = pkgs.fetchurl {
            url = "https://github.com/ShayanAbbas1/dbdelve/releases/download/v${version}/dbdelve-${version}-linux-${arch}.tar.gz";
            inherit hash;
          };

          nativeBuildInputs = with pkgs; [autoPatchelfHook];

          buildInputs = with pkgs; [
            stdenv.cc.cc.lib
            libxcb
            libxkbcommon
            unixodbc
          ];

          # dlopened by GPUI, so autoPatchelf can't see them from NEEDED.
          runtimeDependencies = with pkgs; [libGL wayland];

          dontConfigure = true;
          dontBuild = true;

          # The app finds its plugins in `<dir of its executable>/plugins`, and
          # current_exe() resolves the bin/ symlink to libexec/.
          installPhase = ''
            runHook preInstall

            install -Dm755 dbdelve "$out/libexec/dbdelve/dbdelve"
            cp -R plugins "$out/libexec/dbdelve/plugins"
            mkdir -p "$out/bin"
            ln -s "$out/libexec/dbdelve/dbdelve" "$out/bin/dbdelve"

            install -Dm644 dbdelve.desktop "$out/share/applications/dbdelve.desktop"
            for size in 16 32 64 128 256 512; do
              install -Dm644 "icons/dbdelve-$size.png" \
                "$out/share/icons/hicolor/''${size}x''${size}/apps/dbdelve.png"
            done

            runHook postInstall
          '';

          meta = {
            description = "Fast, native, multi-engine database client";
            homepage = "https://github.com/ShayanAbbas1/dbdelve";
            license = lib.licenses.gpl3Only;
            sourceProvenance = [lib.sourceTypes.binaryNativeCode];
            mainProgram = "dbdelve";
            platforms = builtins.attrNames arches;
          };
        };
    };
}
