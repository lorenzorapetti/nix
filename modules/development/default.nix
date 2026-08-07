{inputs, ...}: {
  den.aspects.development = {
    nixos = {pkgs, ...}: {
      nixpkgs.overlays = [
        inputs.rust-overlay.overlays.default
      ];

      programs.nix-ld.enable = true;

      environment.systemPackages = with pkgs; [
        gcc
        udev
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
            "riscv32imac-unknown-none-elf"
          ];
        })
        cargo-binutils
        cargo-generate
        probe-rs-tools
        rust-analyzer

        gdb
        minicom
        picotool
        libunwind
      ];

      environment.etc."udev/rules.d/69-probe-rs.rules".source = "${pkgs.probe-rs-tools}/lib/udev/rules.d/69-probe-rs.rules";
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
