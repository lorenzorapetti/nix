{inputs, ...}: {
  den.aspects.boot.kernel-cachyos.nixos = {
    nixpkgs.overlays = [
      inputs.nix-cachyos-kernel.overlays.pinned
      # The pinned CachyOS kernels are built against an older nixpkgs that
      # doesn't emit `modules.cer`, but the current module aggregator copies
      # it unconditionally and fails. Skip the certificate merge when it's
      # missing. Drop once https://github.com/xddxdd/nix-cachyos-kernel/issues/111
      # is fixed.
      (_final: prev: {
        aggregateModules = modules:
          (prev.aggregateModules modules).overrideAttrs (old: {
            postBuild =
              builtins.replaceStrings
              [''cd -- "$out/lib/modules/$kernelVersion"'']
              [''cd -- "$out/lib/modules/$kernelVersion"; test -e modules.cer || exit 0'']
              old.postBuild;
          });
      })
    ];

    # The CachyOS patchset ships BBR3 as its own `tcp_bbr3` module (distinct
    # from the in-tree v1 `tcp_bbr`); the stock cached kernels leave it
    # unloaded and default to cubic/fq_codel.
    boot.kernelModules = ["tcp_bbr3" "sch_fq"];
    boot.kernel.sysctl = {
      "net.core.default_qdisc" = "fq";
      "net.ipv4.tcp_congestion_control" = "bbr3";
    };
  };
}
