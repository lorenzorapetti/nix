{
  flake,
  pkgs,
  ...
}: {
  nixpkgs.overlays = [
    flake.inputs.niri.overlays.niri
    (
      final: prev: {
        libdisplay-info = prev.libdisplay-info.overrideAttrs (_: rec {
          version = "0.2.0";
          src = pkgs.fetchFromGitLab {
            domain = "gitlab.freedesktop.org";
            owner = "emersion";
            repo = "libdisplay-info";
            rev = version;
            sha256 = "sha256-6xmWBrPHghjok43eIDGeshpUEQTuwWLXNHg7CnBUt3Q=";
          };
        });
      }
    )
  ];

  imports = [flake.nixosModules.desktop];

  programs.niri.enable = true;
  programs.niri.package = pkgs.niri-unstable;

  environment.variables.NIXOS_OZONE_WL = "1";
}
