{
  den.aspects.ai = {
    homeManager = {
      inputs',
      config,
      osConfig,
      pkgs,
      lib,
      ...
    }: let
      dotfiles = "${config.home.homeDirectory}/nix/dotfiles/claude-code";
      personalConfigDir = "${config.xdg.configHome}/claude-personal";

      # orbit, shared by both claudes: home-manager's generated MCP plugin only
      # lands in the main configDir, so claude-personal gets it via its own
      # --mcp-config.
      orbitMcp = {
        type = "http";
        url = "https://board.lorenzolab.com/mcp";
      };

      # Grafana's MCP server, run natively instead of through the grafana-mcp
      # plugin's `docker run` (the user isn't in the docker group). The token is
      # read from the sops secret at start, so it never lands in the store.
      grafanaMcp = pkgs.writeShellScript "grafana-mcp" ''
        GRAFANA_SERVICE_ACCOUNT_TOKEN="$(cat ${osConfig.sops.secrets.grafana_mcp_token.path})"
        export GRAFANA_SERVICE_ACCOUNT_TOKEN
        export GRAFANA_URL=https://grafana.lorenzolab.com
        # Only the tools for logs, dashboards and alerts (plus search and
        # datasource lookup, which those need) to keep the tool list small.
        exec ${lib.getExe pkgs.mcp-grafana} -t stdio \
          --enabled-tools search,datasource,loki,dashboard,alerting
      '';

      # MCP servers for claude-personal.
      personalMcpConfig = pkgs.writeText "claude-personal-mcp.json" (builtins.toJSON {
        mcpServers = {
          grafana = {
            type = "stdio";
            command = "${grafanaMcp}";
          };
          orbit = orbitMcp;
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
          orbit = {
            enabled = true;
            inherit (orbitMcp) url;
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
        # Token-saving proxy for Bash tool output; both claudes' settings.json
        # register its PreToolUse hook (`rtk hook claude`).
        inputs'.llm-agents.packages.rtk
        (pkgs.writeShellScriptBin "claude-personal" ''
          CLAUDE_CONFIG_DIR=${personalConfigDir} exec claude --mcp-config ${personalMcpConfig} "$@"
        '')
      ];
      home.shellAliases.ccp = "claude-personal";
    };
  };
}
