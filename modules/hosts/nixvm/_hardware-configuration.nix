{
  config,
  lib,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  boot.initrd.availableKernelModules = ["xhci_pci" "ohci_pci" "ehci_pci" "virtio_pci" "ahci" "usbhid" "sr_mod" "virtio_blk"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-amd"];
  boot.extraModulePackages = [];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/1137c84c-ee22-4c39-8628-53fb9df31686";
    fsType = "btrfs";
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/1137c84c-ee22-4c39-8628-53fb9df31686";
    fsType = "btrfs";
    options = ["subvol=nix"];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/1137c84c-ee22-4c39-8628-53fb9df31686";
    fsType = "btrfs";
    options = ["subvol=home"];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/4F12-6A7B";
    fsType = "vfat";
    options = ["fmask=0077" "dmask=0077"];
  };

  swapDevices = [
    {device = "/dev/disk/by-uuid/55a0f8af-9bfd-443d-9207-fb96c5b018fc";}
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
