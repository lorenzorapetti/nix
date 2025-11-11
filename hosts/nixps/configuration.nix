{
  pkgs,
  flake,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    flake.inputs.hardware.nixosModules.dell-xps-13-9340
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

  networking.hostName = "nixps";
  networking.networkmanager.enable = true;

  hardware.bluetooth.enable = true;
  hardware.ipu6.enable = true;
  hardware.ipu6.platform = "ipu6epmtl";

  services.keyboard-interception = {
    enable = true;
    devices = [
      "/dev/input/by-path/platform-i8042-serio-0-event-kbd"
      "/dev/input/gem-80-kbd"
    ];
  };

  services.protonvpn.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      # Required for modern Intel GPUs (Xe iGPU and ARC)
      intel-media-driver # VA-API (iHD) userspace
      vpl-gpu-rt # oneVPL (QSV) runtime

      # Optional (compute / tooling):
      intel-compute-runtime # OpenCL (NEO) + Level Zero for Arc/Xe
      # NOTE: 'intel-ocl' also exists as a legacy package; not recommended for Arc/Xe.
      # libvdpau-va-gl       # Only if you must run VDPAU-only apps
    ];
  };

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD"; # Prefer the modern iHD backend
    # VDPAU_DRIVER = "va_gl";      # Only if using libvdpau-va-gl
  };

  # May help if FFmpeg/VAAPI/QSV init fails (esp. on Arc with i915):
  hardware.enableRedistributableFirmware = true;
  boot.kernelParams = ["i915.enable_guc=3"];

  monitors = [
    {
      name = "eDP-1";

      width = 2560;
      height = 1600;
      refresh = 120.0;

      position = {
        x = 0;
        y = 0;
      };

      scale = 1.3;
    }
  ];

  users.users.lorenzo = {
    isNormalUser = true;
    description = "Lorenzo";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
    ];
  };
}
