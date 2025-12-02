{...}: {
  imports = [
    ./programs.nix
    ./shell
    ./lazygit.nix
    ./dotfiles.nix
    ./direnv.nix
    ./neovim.nix
    ./ai.nix
  ];

  xdg.enable = true;

  home.stateVersion = "25.05";
}
