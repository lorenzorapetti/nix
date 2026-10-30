{
  den.aspects.desktop.coding = {
    # `host` is unused but tells den to apply this in host+user context only.
    # deadnix: skip
    host,
    user,
    ...
  }: {
    nixos = {config, ...}: {
      # Read by the herdr-app `linear` mod.
      sops.secrets.linear_api_key = {};
      sops.templates."herdr-linear.json" = {
        owner = user.name;
        mode = "0600";
        content = builtins.toJSON {apiKey = config.sops.placeholder.linear_api_key;};
      };
    };

    homeManager = {
      inputs',
      self',
      config,
      osConfig,
      ...
    }: {
      home.packages = with inputs'.llm-agents.packages; [
        orca
        ccstatusline
        self'.packages.herdr-app
        self'.packages.herdr-core
      ];

      xdg.configFile = let
        link = path: config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix/dotfiles/${path}";
      in {
        "ccstatusline/settings.json".source = link "ccstatusline/settings.json";
        # Only the hand-edited files: the rest of ~/.config/herdr-app is app state.
        # herdr-app saves through symlinks, so in-app changes land in dotfiles.
        "herdr-app/settings.json".source = link "herdr-app/settings.json";
        "herdr-app/keys.json".source = link "herdr-app/keys.json";
        # Per-mod links: mods/ also holds the mods Herdr ships and rewrites.
        "herdr-app/mods/linear".source = link "herdr-app/mods/linear";
        "herdr-app/mods/linear-agent".source = link "herdr-app/mods/linear-agent";
        "herdr-app/linear.json".source =
          config.lib.file.mkOutOfStoreSymlink osConfig.sops.templates."herdr-linear.json".path;
      };

      programs.zed-editor = {
        enable = true;
      };
    };
  };
}
