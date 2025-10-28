{ config, lib, ... }: let
  inherit (lib) mkIf;

  cfg = config.programs.zed-editor;
in {
  config = {
    programs.zed-editor = mkIf cfg.enable {
      extensions = [ "nix" "rust" "toml" "json" ];

      userSettings = {
        hour_format = "hour24";
        auto_update = false;

        lsp = {
            rust-analyzer = {
            binary = {
                path_lookup = true;
            };
            };

            nix = {
            binary = {
                path_lookup = true;
            };
            };
        };

        vim_mode = true;

        # Tell Zed to use direnv and direnv can use a flake.nix environment
        load_direnv = "shell_hook";

        theme = {
          mode = "dark";
          dark = "Catppuccin Mocha";
        };
      };
    };
  };
}
