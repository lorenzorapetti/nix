{
  den,
  lib,
  ...
}: {
  den.aspects.desktop.hyprland = {
    includes = with den.aspects; [
      desktop
      desktop.wm
      desktop.base-applications
      desktop.agnostic-applications
      desktop.noctalia-greeter
      desktop.noctalia
    ];

    nixos = {
      inputs',
      pkgs,
      ...
    }: {
      environment.systemPackages = with pkgs; [
        runapp
      ];

      programs.hyprland = {
        enable = true;
        withUWSM = true;

        package = inputs'.hyprland.packages.hyprland;
        portalPackage = inputs'.hyprland.packages.xdg-desktop-portal-hyprland;
      };
    };

    homeManager = {
      pkgs,
      inputs',
      ...
    }: {
      # xdg.configFile."hypr/vars.lua".text = ''
      #   return {
      #     terminal = "${lib.getExe pkgs.alacritty}",
      #     browser = "${lib.getExe inputs'.helium.packages.default}",
      #     file_manager = "${lib.getExe pkgs.nautilus}",
      #     yazi = "${lib.getExe pkgs.yazi}",
      #     bluetui = "${lib.getExe pkgs.bluetui}",
      #   }
      # '';

      wayland.windowManager.hyprland = {
        enable = true;
        systemd.enable = true;
        systemd.enableXdgAutostart = true;
        xwayland.enable = true;

        # set the Hyprland and XDPH packages to null to use the ones from the NixOS module
        package = null;
        portalPackage = null;

        configType = "lua";
        extraLuaFiles = {
          "input" = ./config/input.lua;
          "keybinds" = ./config/keybinds.lua;
          "rules" = ./config/rules.lua;
          "style" = ./config/style.lua;
        };
        extraConfig = ''
          require("keybinds")
          require("rules")
          require("input")
          require("style")
        '';
      };

      programs.hyprland-qt-support.enable = true;
    };
  };
}
