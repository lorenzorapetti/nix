{
  flake,
  lib,
  ...
}: let
  inherit (lib) types mkOption;
in {
  imports = [
    flake.inputs.vicinae.homeManagerModules.default
    ./stylix.nix
    ./dotfiles.nix
    ./applications
    ./programs.nix
  ];

  options = {
    programs.webapps = mkOption {
      type = types.attrsOf (types.submodule {
        options = {
          name = mkOption {
            type = types.str;
          };
          url = mkOption {
            type = types.str;
          };
          icon = mkOption {
            type = types.nullOr (types.submodule {
              options = {
                url = mkOption {
                  type = types.str;
                };
                sha256 = mkOption {
                  type = types.str;
                };
              };
            });
            default = null;
          };
        };
      });
      default = {};
    };
  };
}
