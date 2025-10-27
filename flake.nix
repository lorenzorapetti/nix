{
  description = "Nix configuration for my homelab";

  inputs = {
    # Nix Packages
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Nix for MacOS
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    # Home Manager
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    # Follow nixpkgs declared above instead of downloading another one
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # System-wide colorscheming & typography
    stylix.url = "github:danth/stylix/release-25.05";
    stylix.inputs.nixpkgs.follows = "nixpkgs";

    # NixOS profiles for different hardware
    hardware.url = "github:NixOS/nixos-hardware";

    # Map folder structure to flake outputs
    blueprint.url = "github:numtide/blueprint";
    blueprint.inputs.nixpkgs.follows = "nixpkgs";

    # Neovim configuration using Nix
    nixvim.url = "github:nix-community/nixvim";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs: {
    inherit (inputs.blueprint { inherit inputs; })
      checks
      devShells
      formatter
      lib
      nixosConfigurations
      packages
      modules
      ;

    inherit (inputs.self.lib)
      homeModules
      nixosModules
      ;

    home-manager.backupFileExtension = "backup";
  };
}
