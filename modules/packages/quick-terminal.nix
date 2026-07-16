{
  perSystem = {pkgs, ...}: {
    packages.quick-terminal = pkgs.writeShellApplication {
      name = "quick-terminal";
      runtimeInputs = with pkgs; [runapp];
      text = ''
        ghostty --class=com.ghostty.quick_terminal -e "$1"
      '';
    };
  };

  den.default.homeManager = {self', ...}: {
    home.packages = [self'.packages.quick-terminal];
  };
}
