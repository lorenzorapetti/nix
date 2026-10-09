{inputs, ...}: {
  den.aspects.desktop.flatpak = {
    nixos = {
      imports = [inputs.nix-flatpak.nixosModules.nix-flatpak];

      # Apps are declared via `services.flatpak.packages` in the aspect that
      # needs them; nix-flatpak installs them from Flathub on activation.
      services.flatpak = {
        enable = true;
        remotes = [
          {
            name = "flathub";
            location = "https://dl.flathub.org/repo/flathub.flatpakrepo";
          }
        ];
        update.auto = {
          enable = true;
          onCalendar = "weekly";
        };
      };
    };
  };
}
