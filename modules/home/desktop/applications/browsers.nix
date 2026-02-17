{
  lib,
  pkgs,
  perSystem,
  ...
}: {
  config = {
    home.packages = [
      pkgs.ungoogled-chromium
      perSystem.helium.default
    ];

    home.sessionVariables.BROWSER = "${lib.getExe perSystem.helium.default}";
  };
}
