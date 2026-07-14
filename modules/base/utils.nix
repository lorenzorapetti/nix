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

        ripgrep
        fd
        dust
        bat
        btop
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
  };
}
