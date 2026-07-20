{den, ...}: {
  # Nyx host with user Lorenzo.
  den.hosts.x86_64-linux.nyx.users.lorenzo = {};

  den.aspects.nyx = {
    includes = with den.aspects; [
      base
      boot.kernel-latest
      hardware.cpu-intel
      hardware.igpu-intel
      hardware.firmware
    ];

    nixos = {
      hardware.facter.reportPath = ./facter.json;
    };
  };
}
