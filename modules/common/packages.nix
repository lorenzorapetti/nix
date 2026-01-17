{pkgs, ...}: {
  # Base packages shared between Linux and MacOS that are not
  # in the home-manager common module.
  environment.systemPackages = with pkgs; [
    # Basic stuff
    git
    wget
    curl
    gcc

    # Archives
    zip
    xz
    unzip
    p7zip

    # Utils
    ripgrep
    jq
    fzf

    # Misc
    file
    which
    tree
    lsof

    # Editors
    vim
    helix

    # Nix dev
    nixd
    alejandra
    statix
  ];
}
