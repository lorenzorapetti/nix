{
  den.aspects.desktop = {
    nixos = {
      nix = {
        # Bound total build parallelism to max-jobs × cores = 16 threads. The
        # previous `max-jobs = auto` (one job per thread) times a per-job core
        # count allowed 100+ concurrent compilers, which ran the machine out of
        # RAM+swap during large C++ builds (e.g. bambu-studio) and froze it.
        settings = {
          max-jobs = 4;
          cores = 4;
        };

        # Builds yield CPU and disk to the interactive session.
        daemonCPUSchedPolicy = "idle";
        daemonIOSchedClass = "idle";
      };

      # Backstop for the limits above: cage the build daemon's cgroup so a
      # runaway build gets throttled/OOM-killed on its own instead of starving
      # the desktop session. Sized for the ~30G desktop hosts.
      systemd.services.nix-daemon.serviceConfig = {
        MemoryHigh = "18G";
        MemoryMax = "22G";
      };

      # Let systemd-oomd act on runaway user processes too, not just system
      # services.
      systemd.oomd.enableUserSlices = true;
    };
  };
}
