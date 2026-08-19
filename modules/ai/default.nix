{
  den.aspects.ai = {
    homeManager = {lib, ...}: {
      programs = {
        mcp.servers = {
          linear = {
            enabled = true;
            url = "https://mcp.linear.app/mcp";
          };
        };

        opencode = {
          enable = true;
          enableMcpIntegration = true;
          settings = {
            plugins = [
              "@mohak34/opencode-notifier@latest"
            ];
          };

          skills = {
            nix-search = ./skills/nix-search;
          };
        };

        claude-code = {
          enable = true;
          enableMcpIntegration = true;

          skills = {
            nix-search = ./skills/nix-search;
          };
        };
      };

      home.activation.createClaudeWorkDir = lib.hm.dag.entryAfter ["writeBoundary"] ''
        mkdir -p "$HOME/.claude-work"
      '';
    };
  };
}
