{
  den.aspects.hardware.sensors = {
    nixos = {pkgs, ...}: {
      environment.systemPackages = with pkgs; [
        lm_sensors
      ];
    };
  };
}
