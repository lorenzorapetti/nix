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

  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;

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
