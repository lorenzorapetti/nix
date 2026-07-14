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
        };

        claude-code = {
          enable = true;
          enableMcpIntegration = true;
        };
      };
    };
  };
}
