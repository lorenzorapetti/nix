{flake, ...}: {
  imports = [
    flake.inputs.catppuccin.nixosModules.catppuccin
    ./theme.nix
    ./shell.nix
    ./monitors.nix
    ./stylix.nix
    ./bluetooth.nix
    ./sound.nix
    ./video.nix
    ./fonts.nix
    ./sddm.nix
    ./services
    ./applications
  ];
}
