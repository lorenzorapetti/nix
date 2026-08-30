{
  den.aspects.desktop.messaging = {
    nixos = {pkgs, ...}: {
      environment.systemPackages = with pkgs; [
        telegram-desktop
        concord-tui
      ];
    };

    homeManager = {
      programs = {
        vesktop = {
          enable = true;
        };
      };
    };
  };
}
