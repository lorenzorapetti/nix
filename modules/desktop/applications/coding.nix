{
  den.aspects.desktop.coding = {
    homeManager = {
      inputs',
      config,
      ...
    }: {
      home.packages = with inputs'.llm-agents.packages; [
        orca
        ccstatusline
      ];

      xdg.configFile."ccstatusline/settings.json".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix/dotfiles/ccstatusline/settings.json";

      programs.zed-editor = {
        enable = true;
      };
    };
  };
}
