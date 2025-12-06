{flake, ...}: {
  imports = [
    flake.inputs.sops-nix.nixosModules.sops
    ./sops.nix
    ./cache.nix
    ./nix.nix
    ./nixpkgs.nix
    ./language.nix
    ./docker.nix
    ./programs.nix
    ./protonvpn.nix
  ];
}
