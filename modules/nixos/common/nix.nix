{
  config,
  lib,
  ...
}: {
  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];

      warn-dirty = false;

      auto-optimise-store = true;

      trusted-users = lib.attrNames config.home-manager.users;
      trusted-substituters = ["https://vicinae.cachix.org"];
    };
  };

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
  };

  environment.variables.NH_OS_FLAKE = "/home/${config.users.users.lorenzo.name}/nix";

  system.stateVersion = "25.05";
}
