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
      desktop.coding
      development
      development.embedded
      docker
    ];

    nixos = {
      imports = [
        inputs.nixos-hardware.nixosModules.framework-intel-core-ultra-series3
      ];

      hardware = {
        facter.reportPath = ./facter.json;
        intelgpu.driver = "xe";
      };

      # Laptop roams untrusted networks: keep SSH reachable only over the
      # tailnet (tailscale0 is a trusted interface in networking.tailscale).
      services.openssh.openFirewall = false;

      # No hibernation: the swapfile is sized as overflow only, too small to
      # hold a RAM image.
      systemd.sleep.settings.Sleep = {
        AllowHibernation = false;
        AllowHybridSleep = false;
        AllowSuspendThenHibernate = false;
      };

      services = {
        power-profiles-daemon.enable = true;
        upower.enable = true;
        fwupd.extraRemotes = ["lvfs-testing"];
        framework-control.enable = true;
      };
    };

    homeManager = {config, ...}: {
      xdg.configFile."hyprmoncfg/profiles".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix/modules/hosts/hades/hyprmoncfg";
    };
  };
}
