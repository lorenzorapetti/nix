{
  config,
  lib,
  ...
}: let
  cfg = config.programs.starship;
  inherit (lib) mkIf;
in {
  config = mkIf cfg.enable {
    programs.starship = {
      settings = {
        add_newline = true;
        aws.disabled = true;
        gcloud.disabled = true;
        line_break.disabled = true;
      };
    };
  };
}
