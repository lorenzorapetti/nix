{perSystem, ...}: {
  home.packages = [
    perSystem.nvim-nix.default
  ];

  home.sessionVariables.EDITOR = "nvim";
}
