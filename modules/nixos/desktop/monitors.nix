{lib, ...}: let
  inherit (lib) types mkOption;
in {
  options = {
    monitors = mkOption {
      type = types.listOf (types.submodule {
        options = {
          name = mkOption {
            type = types.str;
          };
          width = mkOption {type = types.int;};
          height = mkOption {type = types.int;};
          refresh = mkOption {
            type = types.float;
            default = 60.0;
          };
          scale = mkOption {
            type = types.float;
            default = 1.0;
          };
          position = {
            x = mkOption {
              type = types.int;
              default = 0;
            };
            y = mkOption {
              type = types.int;
              default = 0;
            };
          };
        };
      });
      default = [];
    };
  };
}
