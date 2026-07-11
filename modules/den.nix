{
  inputs,
  lib,
  den,
  ...
}: {
  imports = [
    inputs.den.flakeModule
  ];

  # Special aspect that applies the configuration to all hosts, users and homes.
  den.default = {
    includes = [
      # Sets the system hostname as defined in `den.hosts.<name>.hostName`
      den.batteries.hostname

      # Provides inputs' (the flake’s inputs with system pre-selected) as a top-level module argument.
      den.batteries.inputs'

      # Provides self' (the flake’s self outputs with system pre-selected) as a top-level module argument.
      den.batteries.self'
    ];

    nixos = {
      system.stateVersion = "26.05";

      time.timeZone = "Europe/Rome";

      i18n.defaultLocale = "en_US.UTF-8";

      i18n.extraLocaleSettings = {
        LC_ADDRESS = "it_IT.UTF-8";
        LC_IDENTIFICATION = "it_IT.UTF-8";
        LC_MEASUREMENT = "it_IT.UTF-8";
        LC_MONETARY = "it_IT.UTF-8";
        LC_NAME = "it_IT.UTF-8";
        LC_NUMERIC = "it_IT.UTF-8";
        LC_PAPER = "it_IT.UTF-8";
        LC_TELEPHONE = "it_IT.UTF-8";
        LC_TIME = "it_IT.UTF-8";
      };

      nixpkgs.config.allowUnfree = true;

      nix = {
        optimise.automatic = true;

        settings = {
          use-xdg-base-directories = true;
          experimental-features = [
            "nix-command"
            "flakes"
          ];
          auto-optimise-store = true;

          trusted-users = ["root" "@wheel"];

          warn-dirty = false;
          tarball-ttl = 60 * 60 * 24;
          # From https://jackson.dev/post/nix-reasonable-defaults/
          connect-timeout = 5;
          log-lines = 50;
          min-free = 128000000;
          max-free = 1000000000;
          fallback = true;
        };
      };
    };

    homeManager.home.stateVersion = "26.05";
  };

  den.schema = {
    host = {
      home-manager.enable = true;
    };
    user.classes = lib.mkDefault ["homeManager"];
  };
}
