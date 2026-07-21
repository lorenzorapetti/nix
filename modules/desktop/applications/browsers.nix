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

    mimeApps = [
      {
        mimes = ["text/html" "text/xml" "application/xhtml+xml" "x-scheme-handler/http" "x-scheme-handler/https"];
        app = "helium.desktop";
      }
    ];
  };
}
