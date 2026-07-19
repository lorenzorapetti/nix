{lib, ...}: {
  den.aspects.desktop.base-applications = {
    nixos = {
      pkgs,
      inputs',
      ...
    }: {
      environment.systemPackages = with pkgs; [
        firefox
        inputs'.helium.packages.default
      ];
    };

    homeManager = {
      inputs',
      config,
      ...
    }: let
      helium = inputs'.helium.packages.default;
      browserMimes = lib.listToAttrs (lib.map
        (mime: {
          name = mime;
          value = ["helium.desktop"];
        }) ["text/html" "text/xml" "application/xhtml+xml" "x-scheme-handler/http" "x-scheme-handler/https"]);
    in {
      xdg.mimeApps = lib.mkIf config.xdg.mimeApps.enable {
        associations.added = browserMimes;
        defaultApplications = browserMimes;
      };
    };
  };
}
