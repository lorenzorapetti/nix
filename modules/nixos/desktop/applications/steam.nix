{pkgs, ...}: {
  # TODO: Improve Steam performance
  programs.steam = {
    enable = true;
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
