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

  systemd.user.services.waybar.wants = ["niri.service"];
  systemd.user.services.hypridle.wants = ["niri.service"];

  systemd.user.services.niri-flake-polkit = {
    description = "PolicyKit Authentication Agent provided by niri-flake";
    wantedBy = ["niri.service"];
    after = ["graphical-session.target"];
    partOf = ["graphical-session.target"];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };
}
