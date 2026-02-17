{...}: {
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = ["lorenzo"];
  };

  environment.etc = {
    "1password/custom_allowed_browsers" = {
      text = ''
        firefox
        .zen-wrapped
        zen
        zen-bin
        zen-twilight
        helium
      '';
      mode = "0755";
    };
  };
}
