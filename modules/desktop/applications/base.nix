{den, ...}: {
  # Absolutely necessary apps for every machine
  den.aspects.desktop.base-applications = {
    includes = with den.aspects; [
      desktop._1password
    ];

    nixos = {pkgs, ...}: {
      environment.systemPackages = with pkgs; [
        nautilus
        file-roller
      ];
    };
  };
}
