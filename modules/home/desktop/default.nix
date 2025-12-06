{flake, ...}: {
  imports = [
    flake.inputs.vicinae.homeManagerModules.default
    ./stylix.nix
    ./dotfiles.nix
    ./applications
    ./programs.nix
    ./yazi.nix
  ];
}
