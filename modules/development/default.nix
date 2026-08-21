{den, ...}: {
  den.aspects.development = {
    includes = [
      den.aspects.development.rust
    ];

    nixos = {pkgs, ...}: {
      programs.nix-ld.enable = true;

      environment.systemPackages = with pkgs; [
        gcc
        udev
        tea
        just

        nodejs_26
        deno
        bun
      ];

      users.groups.docker = {};
    };

    homeManager = {config, ...}: {
      programs = {
        direnv = {
          enable = true;
          nix-direnv.enable = true;
          config = {
            global = {
              load_dotenv = true;
              strict_env = true;
            };
            whitelist.prefix = [
              "/etc/nixos"
              "${config.home.homeDirectory}/code"
              "${config.home.homeDirectory}/nix"
            ];
          };
        };
      };

      programs = {
        lazygit.enable = true;
        lazydocker.enable = true;
        gh.enable = true;
        gh-dash.enable = true;
      };
    };

    user.extraGroups = ["docker"];
  };
}
