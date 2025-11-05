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

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 1w";
    };
  };

  system.stateVersion = "25.05";
}
