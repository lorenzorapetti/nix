{
  den.aspects.ai = {
    homeManager = {
      lib,
      config,
      ...
    }: {
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

          skills = {
            nix-search = ./skills/nix-search;
          };
        };
      };

      home.file.".claude/settings.json".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix/dotfiles/claude-code/settings.json";
      home.file.".claude-personal/settings.json".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix/dotfiles/claude-code/settings.json";

      home.activation.createClaudeWorkDir = lib.hm.dag.entryAfter ["writeBoundary"] ''
        mkdir -p "$HOME/.claude-personal"
      '';
    };
  };
}
