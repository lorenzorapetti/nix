{
  pkgs,
  perSystem,
  ...
}:
perSystem.devshell.mkShell {
  # Set name of devshell from config
  devshell.name = "nix-dotfiles";

  # Base list of commands for devshell
  commands = [
    {
      category = "development";
      name = "deploy";
      help = "Create a new generation";
      command =
        if pkgs.stdenv.isLinux
        then "nh os switch"
        else "nh darwin switch";
    }
    {
      category = "development";
      name = "browse";
      help = "Browse flake";
      command = "nix-inspect --path .";
    }
  ];

  # Base list of packages for devshell, plus extra
  packages = with pkgs; [
    # pkgs.age
    git
    nix-inspect

    nixd
    alejandra
    statix
  ];
}
