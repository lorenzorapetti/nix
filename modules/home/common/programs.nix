{
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkDefault;
in {
  home.packages = with pkgs; [
    fzf
    ripgrep
    zoxide # change dir with z

    _1password-cli
    lazydocker # docker tui
    systemctl-tui
    gh # GitHub CLI
    tea # Gitea CLI

    lsd # Better ls
    bat # Better cat
    dust # Better du
    fd # Better find

    fastfetch
  ];

  programs = {
    bash.enable = mkDefault true;
    fish.enable = mkDefault true;
    zsh.enable = mkDefault true;
    starship.enable = mkDefault true;
    lazygit.enable = mkDefault true;
    direnv.enable = mkDefault true;
  };
}
