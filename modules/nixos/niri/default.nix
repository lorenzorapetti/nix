{
  flake,
  pkgs,
  lib,
  ...
}: {
  nixpkgs.overlays = [
    flake.inputs.niri.overlays.niri
  ];

  imports = [flake.nixosModules.desktop];

  programs.niri.enable = true;
  programs.niri.package = pkgs.niri-unstable;

  services.displayManager.sddm.enable = true;

  services.udisks2.enable = true;

  environment.variables.NIXOS_OZONE_WL = "1";

  systemd.user.services.niri-flake-polkit.enable = false;

  # systemd.user.services = let
  #   services = ["waybar" "hypridle" "udiskie" "swayosd"];
  # in
  #   lib.attrsets.mergeAttrsList [
  #     (builtins.listToAttrs (builtins.map (service: {
  #         name = service;
  #         value = {wants = ["niri.service"];};
  #       })
  #       services))
  #     {
  #       niri-flake-polkit = {
  #         description = "PolicyKit Authentication Agent provided by niri-flake";
  #         wantedBy = ["niri.service"];
  #         after = ["graphical-session.target"];
  #         partOf = ["graphical-session.target"];
  #         serviceConfig = {
  #           Type = "simple";
  #           ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
  #           Restart = "on-failure";
  #           RestartSec = 1;
  #           TimeoutStopSec = 10;
  #         };
  #       };
  #     }
  #   ];
}
