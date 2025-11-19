{...}: {
  imports = [
    ./programs.nix
    ./shell
    ./lazygit.nix
    ./dotfiles.nix
    ./direnv.nix
    ./ai.nix
  ];

  xdg.enable = true;

  home.stateVersion = "25.05";
}
