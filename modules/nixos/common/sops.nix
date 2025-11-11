{
  config,
  lib,
  pkgs,
  ...
}: {
  sops = {
    defaultSopsFile = ../../../secrets/secrets.yaml;
    age = {
      generateKey = true;
      sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
      keyFile = "/var/lib/sops-nix/age.agekey";
    };
    secrets.protonvpn-private-key = {};
  };
}
