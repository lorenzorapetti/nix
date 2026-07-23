{
  den.aspects.boot.plymouth = {
    nixos = {
      boot = {
        plymouth.enable = true;
        consoleLogLevel = 0;
        initrd.verbose = false;

        kernelParams = [
          "quiet"
          "splash"
          "boot.shell_on_fail"
          "udev.log_priority=3"
          "rd.systemd.show_status=auto"
        ];

        initrd.systemd.enable = true;
      };
    };
  };
}
