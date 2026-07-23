{
  den.aspects.base = {
    nixos = {
      systemd.user.settings.Manager.DefaultTimeoutStopSec = "10s";
    };
  };
}
