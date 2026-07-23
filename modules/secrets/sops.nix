{inputs, ...}: {
  den.aspects.sops = {
    nixos = {pkgs, ...}: {
      imports = [
        inputs.sops-nix.nixosModules.sops
      ];

      environment.systemPackages = with pkgs; [
        sops
      ];

      environment.sessionVariables = {
        SOPS_AGE_KEY_FILE = "/var/lib/sops-nix/keys.txt";
      };

      sops = {
        defaultSopsFile = ./secrets.yaml;
        age.keyFile = "/var/lib/sops-nix/keys.txt";
      };
    };
  };
}
