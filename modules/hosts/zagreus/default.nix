{
  den,
  lib,
  ...
}: {
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

      nix.settings.cores = 12;

      boot.loader.limine.extraEntries = ''
        /CachyOS
            comment: Chainload CachyOS's own limine bootloader
            protocol: efi
            path: guid(a19d13ab-1f78-4bf8-8e0f-c5c9f33d8217):/EFI/limine/limine_x64.efi
      '';

      # A large parallel C++ build (e.g. bambu-studio) with no cap ran the machine
      # out of RAM+swap and froze it solid, requiring a hard reset. Cage the build
      # daemon's cgroup so a runaway build gets throttled/OOM-killed on its own
      # instead of starving the interactive desktop session. Sized for zagreus's 27G.
      systemd.services.nix-daemon.serviceConfig = {
        MemoryHigh = "18G";
        MemoryMax = "22G";
      };
    };

    homeManager = {
      xdg.configFile = let
        profiles = ["home-dual"];
        extensions = ["conf" "lua" "json"];
      in
        lib.listToAttrs (lib.flatten (lib.map (profile:
          lib.map (ext: {
            name = "hyprmoncfg/profiles/${profile}.${ext}";
            value.source = ./hyprmoncfg/${profile}.${ext};
          })
          extensions)
        profiles));
    };
  };
}
