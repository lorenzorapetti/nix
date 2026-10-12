{self, ...}: {
  perSystem = {pkgs, ...}: {
    formatter = pkgs.alejandra;

    # Lint the whole flake source as part of `nix flake check`.
    checks = {
      statix = pkgs.runCommand "statix" {nativeBuildInputs = [pkgs.statix];} ''
        cd ${self}
        statix check .
        touch $out
      '';

      deadnix = pkgs.runCommand "deadnix" {nativeBuildInputs = [pkgs.deadnix];} ''
        deadnix --fail ${self}
        touch $out
      '';
    };
  };
}
