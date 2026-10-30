# herdr-app (https://github.com/herdrdev/herdr-app): desktop app for terminals and
# coding agents. Built from source following the Nix packaging in
# https://github.com/herdrdev/herdr-app/pull/51 (nix/package.nix).
#
# When bumping, update `rev`/`version` and the src hash, then `ghosttyRev` to the
# commit the `vendor/ghostty` submodule points at, and refresh the ghostty, zig
# deps and cargo hashes together. The app needs herdr-core at or above its
# `distribution/core-version` (see herdr-core.nix).
{
  perSystem = {
    pkgs,
    lib,
    system,
    self',
    ...
  }: let
    platforms = ["x86_64-linux" "aarch64-linux"];
  in
    lib.optionalAttrs (builtins.elem system platforms) {
      packages.herdr-app = let
        version = "0.1.6";
        rev = "8cd3f7c2861ee81122109479b8d905a0866f5bba";
        ghosttyRev = "291fd050b9e9c293c8adb6a140742649b7e42d3a";

        runtimeDependencies = with pkgs; [
          fontconfig
          freetype
          libxcb
          libxkbcommon
          wayland
          vulkan-loader
        ];

        ghostty = pkgs.fetchFromGitHub {
          owner = "ghostty-org";
          repo = "ghostty";
          rev = ghosttyRev;
          hash = "sha256-fXghoRnPzYZ2OZvydGnRSESM9tkLZ8J1912wRip78qY=";
        };

        zigDeps = pkgs.zig_0_16.fetchDeps {
          pname = "herdr-ghostty";
          version = builtins.substring 0 7 ghosttyRev;
          src = ghostty;
          fetchAll = true;
          hash = "sha256-G9xbZ/pyQTDIfzG0h++i70a45zpwyYpZMBZfAnoOQw0=";
        };
      in
        pkgs.rustPlatform.buildRustPackage {
          pname = "herdr-app";
          inherit version;

          # PR #51 head (fork); vendor/ghostty is a submodule, filled in postUnpack.
          src = pkgs.fetchFromGitHub {
            owner = "hackrdotsh";
            repo = "herdr-app";
            inherit rev;
            hash = "sha256-7qpW/qFFCQvs4vljsKeE5DCxug3/055raHeoU08ECNU=";
          };

          cargoHash = "sha256-kvj1pbtdZA5pEQ2l9VRXwB1i8BL51DYCsxO1wxLRe0k=";

          nativeBuildInputs = with pkgs; [
            pkg-config
            clang
            rustPlatform.bindgenHook
            zig_0_16
            makeWrapper
            copyDesktopItems
          ];

          buildInputs = runtimeDependencies;
          LIBCLANG_PATH = "${lib.getLib pkgs.libclang}/lib";

          # Cargo invokes Zig through ghostty-sys, not through Nix's Zig phases.
          dontUseZigConfigure = true;
          dontUseZigBuild = true;
          dontUseZigCheck = true;
          dontUseZigInstall = true;

          postUnpack = ''
            rm -rf "$sourceRoot/vendor/ghostty"
            mkdir -p "$sourceRoot/vendor/ghostty"
            cp -R ${ghostty}/. "$sourceRoot/vendor/ghostty/"
            chmod -R u+w "$sourceRoot/vendor/ghostty"
          '';

          preBuild = ''
            export ZIG_GLOBAL_CACHE_DIR="$TMPDIR/zig-cache"
            mkdir -p "$ZIG_GLOBAL_CACHE_DIR"
            ln -s ${zigDeps} "$ZIG_GLOBAL_CACHE_DIR/p"
          '';

          # The upstream test suite needs a software Vulkan driver and debug-only
          # instrumentation; the install check below is enough of a smoke test.
          doCheck = false;

          desktopItems = [
            (pkgs.makeDesktopItem {
              name = "herdr-app";
              desktopName = "Herdr";
              comment = "Terminals and coding agents that keep running";
              exec = "herdr-app";
              icon = "herdr-app";
              terminal = false;
              categories = ["Development"];
              startupWMClass = "herdr-app";
            })
          ];

          postInstall = ''
            install -Dm644 assets/icons/herdr-ui-icon-clean.svg \
              "$out/share/icons/hicolor/scalable/apps/herdr-app.svg"
            # herdr-core first on PATH, so the app uses this one instead of
            # offering to install its own release into ~/.local/bin.
            wrapProgram "$out/bin/herdr-app" \
              --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath runtimeDependencies} \
              --prefix PATH : ${lib.makeBinPath [self'.packages.herdr-core]} \
              --suffix PATH : ${lib.makeBinPath [pkgs.xdg-utils]}
          '';

          doInstallCheck = true;
          installCheckPhase = ''
            runHook preInstallCheck
            "$out/bin/herdr-app" --help > /dev/null
            "$out/bin/herdr-app" --skill > /dev/null
            runHook postInstallCheck
          '';

          meta = {
            description = "Desktop app for terminals and coding agents";
            homepage = "https://github.com/herdrdev/herdr-app";
            license = lib.licenses.asl20;
            mainProgram = "herdr-app";
            inherit platforms;
          };
        };
    };
}
