# Wraps a prebuilt release AppImage for apps that aren't in nixpkgs. Imported
# manually from `perSystem` blocks (the `_` prefix keeps import-tree from
# loading it); evaluates to a `packages` attrset holding `${pname}`, or to
# nothing when `sources` has no entry for `system`.
#
# When bumping an app, update `version` and every hash in `sources` together:
#   nix store prefetch-file --hash-type sha256 <url>
{
  pkgs,
  lib,
  system,
}: {
  pname,
  version,
  # { <system> = { url, hash }; }
  sources,
  # Basename of the .desktop entry the AppImage ships.
  appId ? pname,
  # appimageContents -> shell snippet. The default ships the AppImage's own
  # .desktop entry and hicolor icon set unchanged, which works when the entry
  # already runs `${pname}`.
  extraInstallCommands ? appimageContents: ''
    install -Dm444 ${appimageContents}/${appId}.desktop -t $out/share/applications
    mkdir -p $out/share/icons
    cp -r ${appimageContents}/usr/share/icons/hicolor $out/share/icons/
  '',
  meta,
}: let
  src = pkgs.fetchurl sources.${system};
  appimageContents = pkgs.appimageTools.extract {inherit pname version src;};
in
  lib.optionalAttrs (sources ? ${system}) {
    ${pname} = pkgs.appimageTools.wrapType2 {
      inherit pname version src;
      extraInstallCommands = extraInstallCommands appimageContents;

      meta =
        {
          sourceProvenance = [lib.sourceTypes.binaryNativeCode];
          platforms = builtins.attrNames sources;
          mainProgram = pname;
        }
        // meta;
    };
  }
