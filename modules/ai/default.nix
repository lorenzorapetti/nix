{
  den.aspects.ai = {
    homeManager = {
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
    };
  };
}
