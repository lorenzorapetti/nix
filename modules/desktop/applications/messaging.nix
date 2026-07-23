{
  den.aspects.desktop.messaging = {
    nixos = {pkgs, ...}: {
      environment.systemPackages = with pkgs; [
        telegram-desktop
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
