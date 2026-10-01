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

        claude-code = {
          enable = true;
          enableMcpIntegration = true;

          skills = {
            nix-search = ./skills/nix-search;
          };
        };

        worktrunk = {
          enable = true;
          enableFishIntegration = true;

          settings = {
            worktree-path = "~/.worktrunk/worktrees/{{ repo }}/{{ branch | sanitize }}";
          };
        };
      };

      home.activation.createClaudeWorkDir = lib.hm.dag.entryAfter ["writeBoundary"] ''
        mkdir -p "$HOME/.claude-personal"
      '';
    };
  };
}
