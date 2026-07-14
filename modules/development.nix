{
  den.aspects.development = {
    nixos = {pkgs, ...}: {
      environment.systemPackages = with pkgs; [
        lazydocker
        gh
        tea
      ];
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

      programs.lazygit.enable = true;
      catppuccin.lazygit.enable = true;
    };
  };
}
