{
  inputs,
  lib,
  ...
}: {
  den.aspects.base.homeManager = {
    imports = [
      inputs.nix-index-database.homeModules.default
    ];

    programs = {
      command-not-found.enable = lib.mkForce false;
      nix-index = {
        enable = true;
        enableBashIntegration = true;
        enableZshIntegration = true;
        enableFishIntegration = true;
      };
      nix-index-database.comma.enable = true;
    };
  };
}
