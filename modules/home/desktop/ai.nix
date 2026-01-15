{...}: {
  programs.opencode = {
    enable = true;
    settings = {
      theme = "catppuccin";
      autoupdate = false;
      permission = {
        bash = "ask";
        edit = "ask";
      };
    };
  };
}
