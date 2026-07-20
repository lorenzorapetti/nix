{
  den.aspects.desktop = {
    homeManager = {lib, ...}: {
      home.activation.createMyDir = lib.hm.dag.entryAfter ["writeBoundary"] ''
        mkdir -p "$HOME/Videos/Recordings"
        mkdir -p "$HOME/Pictures/Screenshots"
        mkdir -p "$HOME/code"
      '';
    };
  };
}
