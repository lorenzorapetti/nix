{inputs, ...}: {
  den.aspects.desktop.vicinae = {
    nixos = {
      imports = [inputs.vicinae.nixosModules.default];

      programs.vicinae.input-server.enable = true;
    };

    homeManager = {inputs', ...}: {
      imports = [inputs.vicinae.homeManagerModules.default];

      programs.vicinae = {
        enable = true;
        enableSoulver = true;
        enableFirefoxIntegration = true;

        systemd = {
          enable = true;
          autoStart = true;
          environment = {
            USE_LAYER_SHELL = 1;
          };
        };

        settings = {
          telemetry = {
            system_info = false;
          };
          providers = {
            applications = {
              defaultAction = "focus";
              launchPrefix = "runapp";
            };
          };
        };

        extensions = with inputs'.vicinae-extensions.packages; [
          nix
          nerdfont-search
        ];
      };
    };
  };
}
