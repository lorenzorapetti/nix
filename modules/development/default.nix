{den, ...}: {
  den.aspects.development = {
    includes = [
      den.aspects.development.rust
    ];

    nixos = {pkgs, ...}: {
      programs.nix-ld.enable = true;

      environment.systemPackages = with pkgs; [
        gcc
        udev
        tea
        just

        nodejs_26
        deno
        bun
      ];
    };

    homeManager = {
      programs = {
        gh.enable = true;
        gh-dash.enable = true;
      };
    };
  };
}
