{...}: {
  imports = [
    ./programs.nix
    ./shell
    ./lazygit.nix
    ./dotfiles.nix
  ];

  home.stateVersion = "25.05";
}
