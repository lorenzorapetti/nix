{den, ...}: {
  den.aspects.desktop.messaging = {
    includes = [den.aspects.desktop.flatpak];

    nixos = {pkgs, ...}: {
      environment.systemPackages = with pkgs; [
        telegram-desktop
        concord-tui
      ];

      services.flatpak.packages = ["app.fluxer.Fluxer"];
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
