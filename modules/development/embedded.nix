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
        version = "0.8.0";

        src = pkgs.fetchCrate {
          inherit pname version;
          hash = "sha256-IKpHZ4ztKINfkfUB4e1ZuQoaH/Le+rz6iEM3TWDElQc=";
        };

        cargoHash = "sha256-q/zp8w4r9uLv16a6+wQgGjdSdOo6YSjfSwIQhYPnntA=";

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
