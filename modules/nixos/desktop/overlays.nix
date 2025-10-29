{ ... }:
{
  nixpkgs.overlays = [
    (_final: prev: {
      firefox = prev.firefox.override {
        extraPolicies = {
          DontCheckDefaultBrowser = true;
          DisablePocket = true;
          DisableFirefoxStudies = true;
        };
      };
    })
  ];
}
