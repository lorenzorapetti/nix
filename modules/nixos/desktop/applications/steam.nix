{pkgs, ...}: {
  # TODO: Improve Steam performance
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
    package = pkgs.steam.override {
      extraArgs = "-system-composer";
    };
    gamescopeSession = {
      enable = true;
      steamArgs = [
        "-system-composer"
      ];
    };
  };

  programs.gamemode.enable = true;

  environment.systemPackages = with pkgs; [
    mangohud
  ];
}
