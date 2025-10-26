{ pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    fzf
    ripgrep
    fish
    zsh
    zoxide # change dir with z

    _1password-cli
    lazydocker # docker tui
    lazygit # git tui

    lsd # Better ls
    bat # Better cat

    direnv # Execute .envrc on dir change
  ];

  programs = {
    starship.enable = lib.mkDefault true;
  };
}
