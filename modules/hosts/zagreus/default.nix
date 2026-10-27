{den, ...}: {
  # Zagreus host with user Lorenzo.
  # It will automatically create a den.aspects.zagreus and den.aspects.lorenzo
  den.hosts.x86_64-linux.zagreus.users.lorenzo = {};

  den.aspects.zagreus = {
    includes = with den.aspects; [
      base
      boot.plymouth
      hardware.cpu-amd
      hardware.igpu-amd
      hardware.firmware
      hardware.btrfs
      networking
      theming.catppuccin
      desktop
      desktop.bluetooth
      desktop.face-unlock
      desktop.hyprland
      desktop.gaming
      desktop.messaging
      desktop.work
      desktop.bambu-studio
      desktop.kicad
      desktop.coding
      development
      development.embedded
      docker
    ];

    nixos = {
      hardware.facter.reportPath = ./facter.json;

      boot.loader.limine.extraEntries = ''
        /CachyOS
            comment: Chainload CachyOS's own limine bootloader
            protocol: efi
            path: guid(a19d13ab-1f78-4bf8-8e0f-c5c9f33d8217):/EFI/limine/limine_x64.efi
      '';
    };

    homeManager = {config, ...}: {
      xdg.configFile."hyprmoncfg/profiles".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix/modules/hosts/zagreus/hyprmoncfg";
    };
  };
}
