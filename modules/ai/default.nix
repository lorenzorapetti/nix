{
  den.aspects.ai = {
    homeManager = {
      config,
      lib,
      ...
    }: let
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

      home.file."${personalConfigDir}/CLAUDE.md".source = ./CLAUDE.md;

      # Claude Code writes settings atomically via a temp file next to the
      # symlink's first hop, so mkOutOfStoreSymlink (which hops through the
      # read-only store) breaks /effort, /model etc. Link straight to dotfiles.
      home.activation.claudeSettings = lib.hm.dag.entryAfter ["linkGeneration"] ''
        run mkdir -p ${config.programs.claude-code.configDir} ${personalConfigDir}
        run ln -sfn ${dotfiles}/settings.json ${config.programs.claude-code.configDir}/settings.json
        run ln -sfn ${dotfiles}/settings-personal.json ${personalConfigDir}/settings.json
      '';

      home.shellAliases.ccp = "CLAUDE_CONFIG_DIR=${personalConfigDir} claude";
    };
  };
}
