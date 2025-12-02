{
  description = "Nix configuration for my homelab";

  inputs = {
    # Nix Packages
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Nix for MacOS
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    # Home Manager
    home-manager.url = "github:nix-community/home-manager/master";
    # Follow nixpkgs declared above instead of downloading another one
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # System-wide colorscheming & typography
    stylix.url = "github:nix-community/stylix/master";
    stylix.inputs.nixpkgs.follows = "nixpkgs";

    # NixOS profiles for different hardware
    hardware.url = "github:lorenzorapetti/nixos-hardware";

    # Map folder structure to flake outputs
    blueprint.url = "github:lorenzorapetti/blueprint";
    blueprint.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    # Developer environments
    devshell.url = "github:numtide/devshell";
    devshell.inputs.nixpkgs.follows = "nixpkgs";

    rust-overlay.url = "github:oxalica/rust-overlay";
    rust-overlay.inputs.nixpkgs.follows = "nixpkgs";

    # Firefox based browser
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    zen-browser.inputs.nixpkgs.follows = "nixpkgs";

    # Scrolling window manager
    niri.url = "github:sodiboo/niri-flake";

    # Launcher inspired by raycast
    vicinae.url = "github:vicinaehq/vicinae";

    # An Answer to your Wayland Wallpaper Woes
    awww.url = "git+https://codeberg.org/LGFae/awww";

    # My neovim config
    nvim-nix.url = "github:lorenzorapetti/nvim-nix";
    nvim-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs: rec {
    inherit
      (inputs.blueprint {inherit inputs;})
      checks
      devShells
      formatter
      lib
      nixosConfigurations
      packages
      modules
      nixosModules
      homeModules
      ;

    commonModules = modules.common;
  };

  nixConfig = {
    extra-substituters = [
      "https://cache.nixos.org/"
      "https://niri.cachix.org/"
      "https://nix-community.cachix.org/"
      "https://vicinae.cachix.org"
    ];
    extra-trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "vicinae.cachix.org-1:1kDrfienkGHPYbkpNj1mWTr7Fm1+zcenzgTizIcI3oc="
    ];
  };
}
