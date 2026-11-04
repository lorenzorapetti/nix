{
  den.aspects.security = {
    nixos = {
      lib,
      pkgs,
      ...
    }: {
      services = {
        pcscd.enable = true;
        udev.packages = [pkgs.yubikey-personalization];

        # gnome-keyring's SSH component fights gpg-agent over SSH_AUTH_SOCK.
        gnome.gcr-ssh-agent.enable = lib.mkForce false;
      };

      environment.systemPackages = [pkgs.yubikey-manager];
    };

    homeManager = {
      lib,
      pkgs,
      ...
    }: {
      programs.gpg = {
        enable = true;

        publicKeys = [
          {
            source = ./pubkey.asc;
            trust = 5;
          }
        ];

        scdaemonSettings.disable-ccid = true;

        settings = {
          personal-cipher-preferences = "AES256 AES192 AES";
          personal-digest-preferences = "SHA512 SHA384 SHA256";
          personal-compress-preferences = "ZLIB BZIP2 ZIP Uncompressed";
          default-preference-list = "SHA512 SHA384 SHA256 AES256 AES192 AES ZLIB BZIP2 ZIP Uncompressed";
          cert-digest-algo = "SHA512";
          s2k-digest-algo = "SHA512";
          s2k-cipher-algo = "AES256";
          charset = "utf-8";
          no-comments = true;
          no-emit-version = true;
          no-greeting = true;
          keyid-format = "0xlong";
          list-options = "show-uid-validity";
          verify-options = "show-uid-validity";
          with-fingerprint = true;
          require-cross-certification = true;
          require-secmem = true;
          no-symkey-cache = true;
          armor = true;
          use-agent = true;
          throw-keyids = true;
        };
      };

      services.gpg-agent = {
        enable = true;
        enableSshSupport = lib.mkForce true;
        enableFishIntegration = true; # sets SSH_AUTH_SOCK / GPG_TTY
        pinentry.package = pkgs.pinentry-gnome3; # older HM: pinentryPackage = ...
      };

      programs.git.signing = {
        key = "0xF1F680022C252805";
        format = "openpgp";
        signByDefault = true;
      };
    };
  };
}
