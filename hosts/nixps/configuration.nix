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

    kernelPackages = pkgs.linuxPackages_latest;
  };

  networking.hostName = "nixps";
  networking.networkmanager.enable = true;

  hardware.bluetooth.enable = true;
  hardware.ipu6.enable = true;
  hardware.ipu6.platform = "ipu6epmtl";

  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
    options = "ctrl:nocaps";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
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

  environment.variables.EDITOR = "nvim";
}
