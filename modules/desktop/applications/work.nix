{
  den.aspects.desktop.work = {
    nixos = {pkgs, ...}: {
      environment.systemPackages = with pkgs; [
        slack
        zoom-us
        teams-for-linux
      ];
    };
  };
}
