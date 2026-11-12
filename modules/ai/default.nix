{
  den.aspects.ai = {
    homeManager = {
      config,
      pkgs,
      lib,
      ...
    }: let
      dotfiles = "${config.home.homeDirectory}/nix/dotfiles/claude-code";
      personalConfigDir = "${config.xdg.configHome}/claude-personal";

      # Yaak's local MCP server (served by the running Yaak app). Shared by both
      # claudes: home-manager's generated MCP plugin only lands in the main
      # configDir, so claude-personal gets it via its own --mcp-config.
      yaakMcp = {
        type = "http";
        url = "http://127.0.0.1:64343/mcp";
      };

      # itsaplan, likewise shared by both claudes.
      itsaplanMcp = {
        type = "http";
        url = "https://plan.lorenzolab.com/api/mcp";
      };

      # MCP servers for claude-personal.
      personalMcpConfig = pkgs.writeText "claude-personal-mcp.json" (builtins.toJSON {
        mcpServers = {
          yaak = yaakMcp;
          kaneo = {
            type = "http";
            url = "https://board.lorenzolab.com/api/mcp";
          };
          itsaplan = itsaplanMcp;
        };
      });
    in {
      programs = {
        mcp.enable = true;
        mcp.servers = {
          linear = {
            enabled = true;
            url = "https://mcp.linear.app/mcp";
          };
          yaak = {
            enabled = true;
            inherit (yaakMcp) url;
          };
          itsaplan = {
            enabled = true;
            inherit (itsaplanMcp) url;
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

      home.file."${personalConfigDir}/CLAUDE.md".source = ./CLAUDE.md;

      # Claude Code writes settings atomically via a temp file next to the
      # symlink's first hop, so mkOutOfStoreSymlink (which hops through the
      # read-only store) breaks /effort, /model etc. Link straight to dotfiles.
      home.activation.claudeSettings = lib.hm.dag.entryAfter ["linkGeneration"] ''
        run mkdir -p ${config.programs.claude-code.configDir} ${personalConfigDir}
        run ln -sfn ${dotfiles}/settings.json ${config.programs.claude-code.configDir}/settings.json
        run ln -sfn ${dotfiles}/settings-personal.json ${personalConfigDir}/settings.json
      '';

      # A real executable, not just an alias: herdr-app starts it from its + menu (programs.json).
      home.packages = [
        (pkgs.writeShellScriptBin "claude-personal" ''
          CLAUDE_CONFIG_DIR=${personalConfigDir} exec claude --mcp-config ${personalMcpConfig} "$@"
        '')
      ];
      home.shellAliases.ccp = "claude-personal";
    };
  };
}
