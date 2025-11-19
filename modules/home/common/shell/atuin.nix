{...}: {
  programs.atuin = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    daemon.enable = true;
    forceOverwriteSettings = true;
    settings = {
      update_check = false;
      enter_accept = true;
      keymap_mode = "vim-insert";
      style = "full";
      theme.name = "catppuccin-mocha-lavender";
    };
    themes = {
      catppuccin-mocha-lavender = {
        theme.name = "catppuccin-mocha-lavender";
        colors = {
          AlertInfo = "#a6e3a1";
          AlertWarn = "#fab387";
          AlertError = "#f38ba8";
          Annotation = "#b4befe";
          Base = "#cdd6f4";
          Guidance = "#9399b2";
          Important = "#f38ba8";
          Title = "#b4befe";
        };
      };
    };
  };
}
