{
  den.aspects.ai = {
    homeManager = {config, ...}: let
      dotfiles = "${config.home.homeDirectory}/nix/dotfiles/claude-code";
      personalConfigDir = "${config.xdg.configHome}/claude-personal";
    in {
      programs = {
        mcp.servers = {
          linear = {
            enabled = true;
            url = "https://mcp.linear.app/mcp";
          };
        };

        claude-code = {
          enable = true;
          enableMcpIntegration = true;
          configDir = "${config.xdg.configHome}/claude";
          context = ./CLAUDE.md;

          skills = {
            nix-search = ./skills/nix-search;
          };
        };
      };

      home.file = {
        "${config.programs.claude-code.configDir}/settings.json".source =
          config.lib.file.mkOutOfStoreSymlink "${dotfiles}/settings.json";
        "${personalConfigDir}/settings.json".source =
          config.lib.file.mkOutOfStoreSymlink "${dotfiles}/settings-personal.json";
        "${personalConfigDir}/CLAUDE.md".source = ./CLAUDE.md;
      };

      home.shellAliases.ccp = "CLAUDE_CONFIG_DIR=${personalConfigDir} claude";
    };
  };
}
