{inputs, ...}: {
  den.aspects.boot.kernel-cachyos.nixos = {
    nixpkgs.overlays = [
      inputs.nix-cachyos-kernel.overlays.pinned
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
