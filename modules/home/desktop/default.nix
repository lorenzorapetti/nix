{flake, ...}: {
  imports = [
    flake.inputs.vicinae.homeManagerModules.default
    flake.inputs.catppuccin.homeModules.catppuccin
    ./stylix.nix
    ./theme.nix
    ./dotfiles.nix
    ./applications
    ./programs.nix
    ./yazi.nix
  ];
}
