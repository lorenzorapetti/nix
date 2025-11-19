{
  config,
  lib,
  ...
}: let
  cfg = config.programs.starship;
  inherit (lib) mkIf concatStrings;
in {
  config = mkIf cfg.enable {
    programs.starship = {
      settings = {
        format = concatStrings [
          "$os"
          "$directory"
          "$character"
        ];
        right_format = concatStrings [
          "$git_branch"
          "$git_status"
          "$git_state"
          "$nix_shell"
          "$line_break"
        ];
        add_newline = true;

        git_branch.format = "[$symbol$branch(:$remote_branch)]($style) ";
        nix_shell = {
          format = "[$symbol]($style)";
          symbol = "❄️";
        };
        os.disabled = false;

        character = {
          success_symbol = "[](bold green)";
          error_symbol = "[](bold red)";
          vimcmd_symbol = "[](bold green)";
          vimcmd_replace_one_symbol = "[](bold purple)";
          vimcmd_replace_symbol = "[](bold purple)";
          vimcmd_visual_symbol = "[](bold yellow)";
        };
      };
    };
  };
}
