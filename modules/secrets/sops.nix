{inputs, ...}: {
  den.aspects.sops = {
    nixos = {pkgs, ...}: {
      imports = [
        inputs.sops-nix.nixosModules.sops
      ];

      environment.systemPackages = with pkgs; [
        sops
      ];

      sops = {
        defaultSopsFile = ./secrets.yaml;
        age.keyFile = "/var/lib/sops-nix/key.txt";
      };
    };
  };
}
