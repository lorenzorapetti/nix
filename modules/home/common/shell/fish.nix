{
  lib,
  config,
  ...
}: let
  starship = config.programs.starship;
  fish = config.programs.fish;

  inherit (lib) mkDefault mkIf mkMerge;
in {
  programs.fish = mkMerge [
    {
      enable = mkDefault true;
    }
    (mkIf fish.enable {
      shellInit = ''
        set -g fish_color_normal cdd6f4
        set -g fish_color_command 89b4fa
        set -g fish_color_param f2cdcd
        set -g fish_color_keyword f38ba8
        set -g fish_color_quote a6e3a1
        set -g fish_color_redirection f5c2e7
        set -g fish_color_end fab387
        set -g fish_color_comment 7f849c
        set -g fish_color_error f38ba8
        set -g fish_color_gray 6c7086
        set -g fish_color_selection --background=313244
        set -g fish_color_search_match --background=313244
        set -g fish_color_option a6e3a1
        set -g fish_color_operator f5c2e7
        set -g fish_color_escape eba0ac
        set -g fish_color_autosuggestion 6c7086
        set -g fish_color_cancel f38ba8
        set -g fish_color_cwd f9e2af
        set -g fish_color_user 94e2d5
        set -g fish_color_host 89b4fa
        set -g fish_color_host_remote a6e3a1
        set -g fish_color_status f38ba8
        set -g fish_pager_color_progress 6c7086
        set -g fish_pager_color_prefix f5c2e7
        set -g fish_pager_color_completion cdd6f4
        set -g fish_pager_color_description 6c7086
      '';

      interactiveShellInit = ''
        set -g fish_greeting
        set -g TERM xterm-256color

        if type -q lsd
            alias ls='lsd'
        end

        if type -q bat
            alias cat='bat'
        else if type -q batcat
            alias cat='batcat'
        end

        if type -q lazygit
            alias lg='lazygit'
        end

        if type -q cargo
            alias c='cargo'
        end

        if type -q helix
          alias hx="helix"
        end
      '';

      functions = {
        mkcd = {
          body = ''
            mkdir -p $argv
            and cd $argv
          '';
        };

        zn = {
          body = ''
            set path (zoxide query --interactive)

            if test -n "$path"
                cd $path
                nvim
            else
                echo "No path found."
            end
          '';
        };
      };
    })
  ];

  programs.starship.enableFishIntegration = mkIf starship.enable true;
}
