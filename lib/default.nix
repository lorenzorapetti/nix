{
  flake,
  inputs,
  ...
}:
let
  # Module args with lib included
  inherit (inputs.nixpkgs) lib;
  args = { inherit flake inputs lib; };

  inherit (builtins)
    attrNames
    attrValues
    filter
    pathExists
    readDir
    ;
  inherit (lib) filterAttrs;
  # Personal helper library
in
rec {
  # Extra flake outputs
  homeModules = import ./homeModules.nix args;
  nixosModules = import ./nixosModules.nix args;

  link = import ./link.nix args;
}
