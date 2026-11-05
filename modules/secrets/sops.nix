{inputs, ...}: {
  den.aspects.sops = {
    nixos = {pkgs, ...}: {
      imports = [
        inputs.sops-nix.nixosModules.sops
      ];

      environment.systemPackages = with pkgs; [
        sops
      ];

      # Decrypts with the SSH host key, which is sops-nix's default.
      sops.defaultSopsFile = ./secrets.yaml;
    };
  };
}
