{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  starshipEnabled = config.programs.starship.enable;
in {
  programs.bash = {
    enable = true;
    enableCompletion = true;
  };

  programs.starship.enableBashIntegration = mkIf starshipEnabled true;
  programs.direnv.enableBashIntegration = true;
}
