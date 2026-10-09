{inputs, ...}: {
  den.aspects.desktop.vicinae = {
    nixos = {
      imports = [inputs.vicinae.nixosModules.default];

      programs.vicinae.input-server.enable = true;
    };

    homeManager = {
      inputs',
      pkgs,
      config,
      ...
    }: {
      imports = [inputs.vicinae.homeManagerModules.default];

      programs.vicinae = {
        package = pkgs.vicinae;
        enable = true;
        enableFirefoxIntegration = true;

        systemd = {
          enable = true;
          autoStart = true;
          environment = {
            USE_LAYER_SHELL = 1;
          };
        };

        extensions = with inputs'.vicinae-extensions.packages; [
          nix
          nerdfont-search
        ];
      };

      home.file.".vicinae/settings.json".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix/dotfiles/vicinae/settings.json";
    };
  };
}
