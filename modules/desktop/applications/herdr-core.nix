# herdr-core (https://github.com/herdrdev/herdr-core): the `hc` terminal server
# that herdr-app runs its terminals and agents in. Built from source the same way
# as herdr-app (Cargo drives Zig to build libghostty-vt from vendor/ghostty).
#
# When bumping, update `version` and the src hash, then `ghosttyRev` to the
# commit the `vendor/ghostty` submodule points at, and refresh the ghostty, zig
# deps and cargo hashes together. Keep it at or above herdr-app's
# `distribution/core-version`.
{
  perSystem = {
    pkgs,
    lib,
    system,
    ...
  }: let
    platforms = ["x86_64-linux" "aarch64-linux"];
  in
    lib.optionalAttrs (builtins.elem system platforms) {
      packages.herdr-core = let
        version = "0.1.14";
        ghosttyRev = "1e5cdb865807abc990181efb8ebfa9122955cce2";

        ghostty = pkgs.fetchFromGitHub {
          owner = "ghostty-org";
          repo = "ghostty";
          rev = ghosttyRev;
          hash = "sha256-WaOzgEyVokKpzYpd+TA12i8qO/4TyQPhH+RWDfvjKe0=";
        };

        zigDeps = pkgs.zig_0_16.fetchDeps {
          pname = "herdr-core-ghostty";
          version = builtins.substring 0 7 ghosttyRev;
          src = ghostty;
          fetchAll = true;
          hash = "sha256-G9xbZ/pyQTDIfzG0h++i70a45zpwyYpZMBZfAnoOQw0=";
        };
      in
        pkgs.rustPlatform.buildRustPackage {
          pname = "herdr-core";
          inherit version;

          # vendor/ghostty is a submodule, filled in postUnpack.
          src = pkgs.fetchFromGitHub {
            owner = "herdrdev";
            repo = "herdr-core";
            rev = "v${version}";
            hash = "sha256-9HYUOGzgFhhqxggt6CrX2db+hIOCBpBs2b9wlOhPKN4=";
          };

          cargoHash = "sha256-A3sxal2nVELUVBJm7g6MsYsT1MhyKo4rDQK0uWmrwQ0=";

          cargoBuildFlags = ["-p" "herdr-core"];

          nativeBuildInputs = [pkgs.zig_0_16];

          # Cargo invokes Zig through ghostty-vt's build.rs, not through Nix's Zig phases.
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

          # The test suite spawns PTYs and long-running servers; the install check
          # below is enough of a smoke test.
          doCheck = false;

          # Upstream's installer puts `hc` beside herdr-core; agents and herdr-app
          # mods call it by that name.
          postInstall = ''
            ln -s herdr-core "$out/bin/hc"
          '';

          doInstallCheck = true;
          installCheckPhase = ''
            runHook preInstallCheck
            "$out/bin/hc" --version | grep -q '^hc ${version}'
            runHook postInstallCheck
          '';

          meta = {
            description = "Terminal server for coding agents, used by herdr-app";
            homepage = "https://github.com/herdrdev/herdr-core";
            license = lib.licenses.asl20;
            mainProgram = "hc";
            inherit platforms;
          };
        };
    };
}
