{lib, ...}: {
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  nixpkgs.config.allowUnfree = lib.mkDefault true;
}
