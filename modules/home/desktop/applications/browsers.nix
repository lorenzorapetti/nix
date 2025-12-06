{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;

  inherit (config.programs) chromium;
in {
  config = {
    xdg.mimeApps = let
      associations = builtins.listToAttrs (map (name: {
          inherit name;
          value = ["brave-browser.desktop"];
        }) [
          "application/x-extension-shtml"
          "application/x-extension-xhtml"
          "application/x-extension-html"
          "application/x-extension-xht"
          "application/x-extension-htm"
          "x-scheme-handler/unknown"
          "x-scheme-handler/mailto"
          "x-scheme-handler/chrome"
          "x-scheme-handler/about"
          "x-scheme-handler/https"
          "x-scheme-handler/http"
          "application/xhtml+xml"
          "application/json"
          "text/plain"
          "text/html"
        ]);
    in {
      associations.added = associations;
      defaultApplications = associations;
    };

    home.packages = with pkgs; [
      ungoogled-chromium
    ];

    home.sessionVariables.BROWSER = "${lib.getExe pkgs.brave}";

    programs.chromium = mkIf chromium.enable {
      package = pkgs.brave;
      extensions = [
        {id = "cjpalhdlnbpafiamejdnhcphjbkeiagm";} # uBlock Origin
        {id = "aeblfdkhhhdcdjpifhhbdiojplfjncoa";} # 1Password
        {id = "dlnejlppicbjfcfcedcflplfjajinajd";} # Bonjour
        {id = "eimadpbcbfnmbkopoojfekhnkhdbieeh";} # Dark Reader
        {id = "cbjhfeooiomphlikkblgdageenemhpgc";} # Atomic CSS Devtools
        {id = "ammjkodgmmoknidbanneddgankgfejfh";} # 7TV
        {id = "eljapbgkmlngdpckoiiibecpemleclhh";} # Fonts Ninja
        {id = "fdpohaocaechififmbbbbbknoalclacl";} # Full Page Screen Capture
        {id = "kbfnbcaeplbcioakkpcpgfkobkghlhen";} # Grammarly
        {id = "edibdbjcniadpccecjdfdjjppcpchdlm";} # I still don't care about cookies
        {id = "neebplgakaahbhdphmkckjjcegoiijjo";} # Keepa
        {id = "kdmnjgijlmjgmimahnillepgcgeemffb";} # Pocket Tube
        {id = "ldgfbffkinooeloadekpmfoklnobpien";} # Raindrop
        {id = "fmkadmapgofadopljbjfkapdkoienihi";} # React Developer Tools
        {id = "hlepfoohegkhhmjieoechaddaejaokhf";} # Refined Github
        {id = "mnjggcdmjocbbbhaepdhchncahnbgone";} # Sponsorblock
        {id = "dhdgffkkebhmkfjojejmpbldmpobfkfo";} # Tampermonkey
        {id = "dbepggeogbaibhgnhhndojpepiihcmeb";} # Vimium
        {id = "gppongmhjkpfnbhagpmjfkannfbllamg";} # Wappalyzer
      ];
    };
  };
}
