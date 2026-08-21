{den, ...}: {
  den.aspects.development.embedded = {
    includes = [
      den.aspects.development.rust
    ];

    rustTargets.targets = [
      "thumbv7em-none-eabihf"
      "thumbv7m-none-eabi"
      "thumbv8m.main-none-eabihf"
      "riscv32imac-unknown-none-elf"
    ];

    nixos = {
      pkgs,
      lib,
      ...
    }: let
      esp-config = pkgs.rustPlatform.buildRustPackage rec {
        pname = "esp-config";
        version = "0.7.0";

        src = pkgs.fetchCrate {
          inherit pname version;
          hash = "sha256-1vEdp6ln0B72xEOcd4Tci9tG3ij62IDm7Kh4HhB37Lc=";
        };

        cargoHash = "sha256-BP2AVHNkqNJ/LZtkQS4H5+x2H6YfqWu4cVMeir5Mkqs=";

        buildFeatures = ["tui"];

        meta = with lib; {
          description = "Configure projects using esp-hal and related packages";
          homepage = "https://github.com/esp-rs/esp-hal/tree/main/esp-config";
          license = with licenses; [mit asl20];
          mainProgram = "esp-config";
        };
      };
    in {
      environment.systemPackages = with pkgs; [
        probe-rs-tools
        esp-generate
        espup
        espflash
        esp-config

        gdb
        minicom
        picotool
        libunwind
      ];

      services.udev.packages = [
        pkgs.probe-rs-tools
      ];

      users.groups.plugdev = {};
    };

    user.extraGroups = ["plugdev"];
  };
}
