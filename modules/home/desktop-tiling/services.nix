{lib, ...}: {
  services.mako.enable = lib.mkDefault true;
  services.udiskie = {
    enable = true;
    automount = true;
    notify = true;
  };

  services.batsignal = {
    enable = lib.mkDefault true;
  };
}
