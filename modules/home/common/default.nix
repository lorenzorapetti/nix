{...}: {
  imports = [
    ./programs.nix
    ./shell
    ./lazygit.nix
    ./dotfiles.nix
    ./direnv.nix
  ];

  xdg.enable = true;

  home.stateVersion = "25.05";
}
