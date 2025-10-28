{
  config,
  lib,
  ...
}: let
  inherit (lib) mkDefault mkIf;

  cfg = config.programs.direnv;
in {
  config = mkIf cfg.enable {
    programs.direnv = {
      nix-direnv.enable = mkDefault true;
      config = {
        global.load_dotenv = true;
        global.strict_env = true;
        whitelist.prefix = [
          "/etc/nixos"
          "${config.home.homeDirectory}/code"
          "${config.home.homeDirectory}/nix"
        ];
      };
    };
  };
}
