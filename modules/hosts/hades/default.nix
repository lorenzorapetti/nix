{
  den,
  inputs,
  ...
}: {
  den.hosts.x86_64-linux.hades.users.lorenzo = {};

  den.aspects.hades = {
    includes = with den.aspects; [
      base
      boot.plymouth
      hardware.btrfs
      networking
      theming.catppuccin
      desktop
      desktop.bluetooth
      desktop.hyprland
      desktop.gaming
      desktop.messaging
      desktop.work
      desktop.bambu-studio
      desktop.kicad
      desktop.ai
      development
      development.embedded
      docker
    ];

    nixos = {pkgs, ...}: {
      imports = [
        inputs.nixos-hardware.nixosModules.framework-intel-core-ultra-series3
      ];

      hardware = {
        facter.reportPath = ./facter.json;
        graphics.enable = true;
        intelgpu.driver = "xe";
      };

      nix.settings.cores = 10;

      # A large parallel C++ build (e.g. bambu-studio) with no cap ran the machine
      # out of RAM+swap and froze it solid, requiring a hard reset. Cage the build
      # daemon's cgroup so a runaway build gets throttled/OOM-killed on its own
      # instead of starving the interactive desktop session. Sized for zagreus's 27G.
      systemd.services.nix-daemon.serviceConfig = {
        MemoryHigh = "18G";
        MemoryMax = "22G";
      };

      services = {
        power-profiles-daemon.enable = true;
        upower.enable = true;
        fwupd.extraRemotes = ["lvfs-testing"];
      };

      environment.systemPackages = with pkgs; [
        brightnessctl
      ];
    };

    homeManager = {config, ...}: {
      xdg.configFile."hyprmoncfg/profiles".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix/modules/hosts/hades/hyprmoncfg";
    };
  };
}
