# linear-cli (https://github.com/schpet/linear-cli): the Linear issue tracker from
# the terminal. Packaged from the prebuilt release binaries.
#
# When bumping, update `version` and every hash in `sources` together; the
# release's sha256.sum lists them (convert with `nix hash convert --to sri`).
{
  perSystem = {
    pkgs,
    lib,
    system,
    ...
  }: let
    version = "3.0.0";
    sources = {
      x86_64-linux = {
        target = "x86_64-unknown-linux-gnu";
        hash = "sha256-UGSmOn5qi1iTpVDhOMCnujc6rWXUJd3msrZrUKbBAok=";
      };
      aarch64-linux = {
        target = "aarch64-unknown-linux-gnu";
        hash = "sha256-9lgBhfOgfFWMZN5EUG165WwTYVx9ITnlzSL/OwOCL80=";
      };
    };
  in
    lib.optionalAttrs (sources ? ${system}) {
      packages.linear-cli = let
        inherit (sources.${system}) target hash;
      in
        pkgs.stdenv.mkDerivation {
          pname = "linear-cli";
          inherit version;

          src = pkgs.fetchurl {
            url = "https://github.com/schpet/linear-cli/releases/download/v${version}/linear-${target}.tar.xz";
            inherit hash;
          };

          nativeBuildInputs = [pkgs.autoPatchelfHook pkgs.installShellFiles];
          buildInputs = [pkgs.stdenv.cc.cc.lib];

          installPhase = ''
            runHook preInstall
            install -Dm755 linear -t $out/bin
            runHook postInstall
          '';

          # autoPatchelfHook normally runs after postFixup; patch now so the
          # binary can run to generate its completions.
          postFixup = ''
            autoPatchelf $out
            installShellCompletion --cmd linear \
              --bash <($out/bin/linear completions bash) \
              --fish <($out/bin/linear completions fish) \
              --zsh <($out/bin/linear completions zsh)
          '';

          meta = {
            description = "Linear issue tracker from the command line";
            homepage = "https://github.com/schpet/linear-cli";
            license = lib.licenses.isc;
            mainProgram = "linear";
            sourceProvenance = [lib.sourceTypes.binaryNativeCode];
            platforms = builtins.attrNames sources;
          };
        };
    };

  den.aspects.shell.homeManager = {self', ...}: {
    home.packages = [self'.packages.linear-cli];
  };
}
