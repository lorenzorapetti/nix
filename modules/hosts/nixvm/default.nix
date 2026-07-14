{den, ...}: {
  den.hosts.x86_64-linux.nixvm.users.lorenzo = {};

  den.aspects.nixvm = {
    includes = with den.aspects; [
      base
      theming.catppuccin
      desktop.hyprland
      development
    ];

    nixos.imports = [
      ./_hardware-configuration.nix
    ];
  };
}
