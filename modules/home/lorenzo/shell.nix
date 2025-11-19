{
  lib,
  config,
  osConfig,
  ...
}: let
  inherit (lib) mkIf;

  atuin = config.programs.atuin;
in {
  programs.atuin = mkIf atuin.enable {
    settings = {
      key_path = osConfig.sops.secrets.lorenzo-atuin-encryption-key.path;
      session_path = osConfig.sops.secrets.lorenzo-atuin-session.path;
    };
  };
}
