{
  config,
  lib,
  inputs,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.services.vicinae;
  style = config.stylix;
in {
  config = {
    services.vicinae = mkIf cfg.enable {
      autoStart = true;

      settings = {
        closeOnFocusLoss = false;
        faviconService = "twenty";
        font = {
          size = style.fonts.sizes.applications;
          normal = style.fonts.sansSerif.name;
        };
        theme = {
          name = "catppuccin-mocha";
          iconTheme = "Catppuccin Mocha Dark";
        };
        rootSearch.searchFiles = false;
        popToRootOnClose = true;
        window = {
          csd = true;
          opacity = 0.9;
          rounding = 10;
        };
      };

      extensions = [
        (inputs.vicinae.mkVicinaeExtension.${pkgs.system} {
          inherit pkgs;
          name = "awww-switcher";
          src = pkgs.fetchFromGitHub {
            # You can also specify different sources other than github
            owner = "lorenzorapetti";
            repo = "awww-switcher";
            rev = "a8539bf44faefe6652b5d1ab25f3f06fa78f607a"; # If the extension has no releases use the latest commit hash
            # You can get the sha256 by rebuilding once and then copying the output hash from the error message
            sha256 = "sha256-3FT1j9xTF/72hfzgJnR1ebPRLccOYhOSIQuCI3IxqUo=";
          }; # If the extension is in a subdirectory you can add ` + "/subdir"` between the brace and the semicolon here
        })
      ];
    };
  };
}
