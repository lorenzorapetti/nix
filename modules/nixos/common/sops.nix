{config, ...}: {
  sops = {
    defaultSopsFile = ../../../secrets/secrets.yaml;
    age = {
      generateKey = true;
      keyFile = "/var/lib/sops-nix/age.agekey";
    };
    secrets = {
      protonvpn-private-key = {};
      lorenzo-atuin-encryption-key = {
        owner = config.users.users.lorenzo.name;
      };
      lorenzo-atuin-session = {
        owner = config.users.users.lorenzo.name;
      };
    };
  };

  environment.variables = {
    SOPS_AGE_KEY_FILE = "/var/lib/sops-nix/age.agekey";
  };
}
