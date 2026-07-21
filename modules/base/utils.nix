{
  den.aspects.base = {
    nixos = {pkgs, ...}: {
      environment.systemPackages = with pkgs; [
        git
        wget
        curl
        gnumake
        inetutils
        nmap
        usbutils
        pciutils
        dnsutils
        zip
        xz
        unzip
        p7zip
        wl-clipboard

        ripgrep
        fd
        dust
        bat
        zoxide
        eza
        systemctl-tui
        fastfetch

        jq
        fzf
        file
        which
        tree
        lsof
        vim
        neovim
      ];
    };

    homeManager = {inputs', ...}: {
      home.packages = [
        inputs'.nvim-nix.packages.default
      ];

      home.sessionVariables.EDITOR = "nvim";
    };
  };
}
