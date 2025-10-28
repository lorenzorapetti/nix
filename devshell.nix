{
  pkgs,
  perSystem,
  # flake,
  ...
}:
perSystem.devshell.mkShell {
  # Set name of devshell from config
  devshell.name = "nix-dotfiles";

  # Base list of commands for devshell
  commands = [
    {
      category = "development";
      name = "switch";
      help = "Create a new generation";
      command = "sudo nixos-rebuild switch --flake .";
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
    # pkgs.alejandra
    git
    nix-inspect

    nixd
    alejandra
    statix
    # pkgs.openssl
    # (pkgs.python3.withPackages (ps: [ ps.cryptography ]))
    # perSystem.self.agenix
    # perSystem.self.default
    # perSystem.self.derive
    # perSystem.self.ipaddr
    # perSystem.self.sshed
  ];
}
