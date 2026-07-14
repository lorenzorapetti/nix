{
  # Applications that are agnostic to the desktop environment, but are necessary.
  den.aspects.desktop.agnostic-applications = {
    nixos = {pkgs, ...}: {
      environment.systemPackages = with pkgs; [
        nautilus
        file-roller
      ];
    };
  };
}
