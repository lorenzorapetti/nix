{...}: {
  imports = [
    ./programs.nix
    ./shell
    ./lazygit.nix
    ./dotfiles.nix
    ./direnv.nix
  ];

  home.stateVersion = "25.05";
}
