{
  pkgs,
  flake,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
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

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable thermald and tlp for power management
  powerManagement.enable = true;
  services.thermald.enable = true;
  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

      CPU_MIN_PERF_ON_AC = 0;
      CPU_MAX_PERF_ON_AC = 100;
      CPU_MIN_PERF_ON_BAT = 0;
      CPU_MAX_PERF_ON_BAT = 50;
    };
  };

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

  # Keyboard input path for udevmon to replace caps with esc/ctrl
  environment.variables.DEVNODE = "/dev/input/event0";

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
