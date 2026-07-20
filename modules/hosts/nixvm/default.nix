{den, ...}: {
  den.hosts.x86_64-linux.nixvm.users.lorenzo = {};

  den.aspects.nixvm = {
    includes = with den.aspects; [
      base
      boot.kernel-latest
      theming.catppuccin
      desktop.hyprland
      development
    ];

    nixos.imports = [
      ./_hardware-configuration.nix
    ];
  };
}
