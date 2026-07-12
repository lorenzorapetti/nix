{
  den.aspects.desktop._1password = {
    nixos = {user, ...}: {
      programs._1password-gui = {
        enable = true;
        polkitPolicyOwners = [user.meta.username];
      };

      environment.etc = {
        "1password/custom_allowed_browsers" = {
          text = ''
            .zen-wrapped
            zen
            zen-bin
            zen-twilight
            helium
            helium-browser
          '';
          mode = "0755";
        };
      };
    };
  };
}
