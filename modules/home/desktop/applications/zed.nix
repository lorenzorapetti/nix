{
  config,
  osConfig,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.programs.zed-editor;
  fonts = osConfig.stylix.fonts;
in {
  config = {
    programs.zed-editor = mkIf cfg.enable {
      extensions = [
        "nix"
        "rust"
        "toml"
        "json"
        "catppuccin"
      ];

      userSettings = {
        hour_format = "hour24";
        auto_update = false;

        buffer_font_family = fonts.monospace.name;

        languages = {
          Nix = {
            language_servers = [
              "nixd"
              "!nil"
            ];

            formatter = {
              external = {
                command = "alejandra";
                arguments = [
                  "--quiet"
                  "--"
                ];
              };
            };
          };
        };

        lsp = {
          rust-analyzer = {
            binary = {
              path_lookup = true;
            };
          };

          nixd = {
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
          light = "Catppuccin Latte";
        };
      };
    };
  };
}
