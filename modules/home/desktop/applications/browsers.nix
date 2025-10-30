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
    # programs.firefox = mkIf firefox.enable {
    #   profiles.default = {
    #     "mousewheel.default.delta_multiplier_y" = 150; # scroll faster
    #   };
    # };

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
