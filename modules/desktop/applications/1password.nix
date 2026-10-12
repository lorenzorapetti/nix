{
  den.aspects.desktop._1password = {
    # `host` is unused but tells den to apply this in host+user context only.
    # deadnix: skip
    host,
    user,
    ...
  }: {
    nixos = {
      programs._1password.enable = true;
      programs._1password-gui = {
        enable = true;
        polkitPolicyOwners = [
          user.name
        ];
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

    homeManager = {pkgs, ...}: {
      xdg.autostart.entries = [
        (pkgs.writeTextFile {
            name = "1password-autostart.desktop";
            destination = "/1password.desktop";
            text = ''
              [Desktop Entry]
              Name=1Password
              Exec=1password --silent
              Terminal=false
              Type=Application
              Icon=1password
              StartupWMClass=1Password
              Comment=Password manager and secure wallet
              MimeType=x-scheme-handler/onepassword;
              Categories=Office;
              X-GNOME-Autostart-enabled=true
            '';
          }
          + "/1password.desktop")
      ];
    };
  };
}
