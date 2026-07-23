{
  den.aspects.desktop.printing = {
    nixos = {pkgs, ...}: {
      services.printing = {
        enable = true;
        drivers = with pkgs; [
          cups-filters
          cups-browsed
        ];
      };
    };
  };
}
