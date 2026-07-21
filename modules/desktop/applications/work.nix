{
  den.aspects.desktop.work = {
    nixos = {pkgs, ...}: {
      environment.systemPackages = with pkgs; [
        slack
        teams-for-linux
      ];
    };
  };
}
