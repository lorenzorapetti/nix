{
  # Services that are needed for window managers without a full desktop environment.
  den.aspects.desktop.wm = {
    nixos = {pkgs, ...}: {
      services.gnome.gnome-keyring.enable = true;

      # fprintAuth defaults to true for any PAM service using useDefaultRules
      # as soon as fprintd is enabled anywhere. It's placed before pam_unix in
      # the auth stack with control "sufficient", so a fingerprint check would
      # short-circuit login before the password ever reaches pam_gnome_keyring,
      # leaving the keyring locked after login.
      security.pam.services.login.fprintAuth = false;
      services.gvfs.enable = true;
      services.samba-wsdd.enable = true;
      services.udisks2 = {
        enable = true;
      };

      programs = {
        seahorse.enable = true;
        gpu-screen-recorder.enable = true;
      };
    };
  };
}
