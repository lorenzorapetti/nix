{inputs, ...}: {
  den.aspects.development = {
    nixos = {pkgs, ...}: {
      nixpkgs.overlays = [
        inputs.rust-overlay.overlays.default
      ];

      environment.systemPackages = with pkgs; [
        tea
        just

        nodejs_26
        deno
        bun

        (rust-bin.stable.latest.default.override {
          extensions = ["llvm-tools"];
          targets = [
            "thumbv7em-none-eabihf"
            "thumbv7m-none-eabi"
            "thumbv8m.main-none-eabihf"
          ];
        })
        cargo-binutils
        cargo-generate
        probe-rs-tools
        rust-analyzer

        gdb
        minicom
        libunwind
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

      programs = {
        lazygit.enable = true;
        lazydocker.enable = true;
        gh.enable = true;
        gh-dash.enable = true;
      };
    };
  };
}
