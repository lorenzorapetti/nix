{flake, ...}: {
  imports = [
    flake.inputs.vicinae.homeManagerModules.default
    ./stylix.nix
    ./applications
    ./programs.nix
  ];
}
