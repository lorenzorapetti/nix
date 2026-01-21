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

    kernelParams = [
      "amdgpu.dc=1"
      "amdgpu.accel=1"
    ];

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
  services.xserver.videoDrivers = ["amdgpu"];

  services.seatd.enable = true;

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

  # Disable internal bluetooth device
  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTRS{idVendor}=="8087", ATTRS{idProduct}=="0029", ATTR{authorized}="0"
  '';

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

      scale = 1.333333;
    }
    {
      name = "DP-3";

      width = 2880;
      height = 1800;
      refresh = 120.0;

      position = {
        x = 960;
        y = 1620;
      };

      scale = 1.33334;
    }
  ];

  environment.systemPackages = with pkgs; [
    mesa
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
      "render"
      "seat"
    ];
  };
}
