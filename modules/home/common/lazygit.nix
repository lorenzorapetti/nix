{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.programs.lazygit;
in {
  config = {
    programs.lazygit = mkIf cfg.enable {
      settings = {
        gui = {
          theme = {
            activeBorderColor = ["#b4befe" "bold"];
            inactiveBorderColor = ["#a6adc8"];
            optionsTextColor = ["#89b4fa"];
            selectedLineBgColor = ["#313244"];
            cherryPickedCommitBgColor = ["#45475a"];
            cherryPickedCommitFgColor = ["#b4befe"];
            unstagedChangesColor = ["#f38ba8"];
            defaultFgColor = ["#cdd6f4"];
            searchingActiveBorderColor = ["#f9e2af"];
          };
        };
      };
    };
  };
}
