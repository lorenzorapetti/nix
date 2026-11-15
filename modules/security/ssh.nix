{
  config,
  lib,
  ...
}: {
  options.sshKeys.yubikey = lib.mkOption {
    type = lib.types.str;
    readOnly = true;
    # Authentication subkey of the GPG key on the YubiKey (gpg --export-ssh-key).
    default = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILROQ7svsJV5adPb1j6VQDhfR47HNPlU92As6wRmzr0v";
    description = "Public SSH key of the YubiKey, authorized for root and the users on every host.";
  };

  config.den.default.nixos = {
    services.openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "prohibit-password";
      };
    };

    # Remote deploys (`just nyx`) log in as root.
    users.users.root.openssh.authorizedKeys.keys = [config.sshKeys.yubikey];
  };
}
