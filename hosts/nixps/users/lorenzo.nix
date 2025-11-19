{flake, ...}: {
  imports = [
    flake.homeModules.common
    flake.inputs.niri.homeModules.config
    flake.homeModules.niri
    flake.homeModules.lorenzo
  ];

  programs.claude-code.enable = true;
}
