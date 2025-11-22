{pkgs, ...}: {
  programs.yazi = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
  };

  xdg.configFile."yazi/theme.toml".source = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/catppuccin/yazi/043ffae14e7f7fcc136636d5f2c617b5bc2f5e31/themes/mocha/catppuccin-mocha-lavender.toml";
    hash = "sha256-6wOYLoEJnzx7XSeZdENqCGIed60KM5ZGAhvDT2GbeKE=";
  };
}
