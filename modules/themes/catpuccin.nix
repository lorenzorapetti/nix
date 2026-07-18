{
  inputs,
  lib,
  ...
}: {
  den.aspects.theming.catppuccin = {
    nixos = {
      imports = [
        inputs.catppuccin.nixosModules.catppuccin
      ];

      catppuccin = {
        enable = true;
        autoEnable = false;
        flavor = "mocha";
        accent = "lavender";

        limine.enable = true;
        tty.enable = true;
      };
    };

    homeManager = {config, ...}: {
      imports = [
        inputs.catppuccin.homeModules.catppuccin
      ];

      catppuccin = {
        alacritty.enable = true;
        bat.enable = true;
        btop.enable = true;
        cursors.enable = true;
        eza.enable = true;
        fcitx5.enable = true;
        fish.enable = true;
        fzf.enable = true;
        gh-dash.enable = config.programs.gh-dash.enable;
        ghostty.enable = true;
        gtk.icon.enable = true;
        imv.enable = config.programs.imv.enable;
        mpv.enable = config.programs.mpv.enable;
        hyprland.enable = config.wayland.windowManager.hyprland.enable;
        lazygit.enable = config.programs.lazygit.enable;
        opencode.enable = config.programs.opencode.enable;
        starship.enable = config.programs.starship.enable;
        zellij.enable = true;
      };

      programs.television.settings = lib.mkIf config.programs.television.enable {
        theme = "catppuccin";
      };

      xdg.configFile = lib.mkIf config.wayland.windowManager.hyprland.enable {
        "hypr/themes/theme.lua".text = ''
          local colors = require("themes.catppuccin")

          local inactiveAlpha = colors.overlay0 .. 'aa'
          local baseAlpha = colors.base .. 'ee'

          local function gradient(color_start, color_end, angle)
            return {
              colors = { M.color(color_start), M.color(color_end) },
              angle = angle or 0,
            }
          end

          local theme = {
            col_active_border = gradient(colors.lavender, colors.blue, 45),
            col_inactive_border = inactiveAlpha,
            shadow = baseAlpha,
            group_border_active = colors.lavender,
            group_border_inactive = inactiveAlpha,
            group_border_locked_active = colors.maroon,
            group_border_locked_inactive = inactiveAlpha,
            groupbar_text = colors.crust,
            groupbar_active = colors.lavender,
            groupbar_inactive = inactiveAlpha,
            groupbar_locked_active = colors.lavender,
            groupbar_locked_inactive = inactiveAlpha,
          }

          return theme
        '';

        "hypr/colors.lua".text = ''
          local theme = require("themes.theme")

          hl.config {
            general = {
              col = {
                active_border = theme.col_active_border,
                inactive_border = theme.col_inactive_border,
              },
            },

            decoration = {
              shadow = {
                color = theme.shadow,
              },
            },

            group = {
              col = {
                border_active = theme.group_border_active,
                border_inactive = theme.group_border_inactive,
                border_locked_active = theme.group_border_locked_active,
                border_locked_inactive = theme.group_border_locked_inactive,
              },

              groupbar = {
                text_color = theme.groupbar_text,
                col = {
                  active = theme.groupbar_active,
                  inactive = theme.groupbar_inactive,
                  locked_active = theme.groupbar_locked_active,
                  locked_inactive = theme.groupbar_locked_inactive,
                },
              },
          },
        '';
      };
    };
  };
}
