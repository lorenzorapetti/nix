{
  flake,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    flake.inputs.hardware.nixosModules.common-hidpi
    flake.inputs.hardware.nixosModules.common-cpu-amd
    flake.inputs.hardware.nixosModules.common-cpu-amd-pstate
    flake.inputs.hardware.nixosModules.common-cpu-amd-zenpower
    flake.nixosModules.common
    flake.nixosModules.niri
  ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      systemd-boot.configurationLimit = 10;
      efi.canTouchEfiVariables = true;
    };

    kernelPackages = pkgs.linuxPackages_zen;
  };

  networking.hostName = "bee";
  networking.networkmanager.enable = true;

  hardware.bluetooth.enable = true;
  hardware.enableRedistributableFirmware = true;
  hardware.uinput.enable = true;
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  hardware.amdgpu.initrd.enable = true;

  # Trim SSDs weekly (harmless on HDDs)
  services.fstrim = {
    enable = true;
    interval = "weekly";
  };

  # ZRAM swap with zstd
  zramSwap = {
    enable = true;
    algorithm = "zstd";
  };

  services.kanata.enable = false;

  services.protonvpn.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Unblock Bluetooth on boot
  systemd.services.unblock-bluetooth = {
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.util-linux}/bin/rfkill unblock bluetooth";
    };
  };

  monitors = [
    {
      name = "HDMI-A-1";

      width = 3840;
      height = 2160;
      refresh = 120.0;

      position = {
        x = 0;
        y = 0;
      };

      scale = 1.33334;
    }
  ];

  users.groups = {
    input = {};
    uinput = {};
    plugdev = {};
  };

  users.users.lorenzo = {
    isNormalUser = true;
    description = "Lorenzo";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
      "uinput"
      "input"
      "plugdev"
    ];
  };
}
