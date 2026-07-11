{den, ...}: {
  den.hosts.x86_64-linux.nixvm.users.lorenzo = {};

  den.aspects.nixvm = {
    includes = with den.aspects; [
      boot.kernel-latest
      boot.limine
      theming.catppuccin
      networking.networkmanager
    ];
  };
}
