{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.programs.claude-code;
in {
  config = mkIf cfg.enable {
    programs.claude-code = {
      settings = {
        includeCoAuthoredBy = false;
      };
    };
  };
}
