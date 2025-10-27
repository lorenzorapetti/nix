{ _ }:
{
  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];

      warn-dirty = false;

      auto-optimise-store = true;
    };

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 1w";
    };
  };
}
