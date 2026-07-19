{inputs, ...}: {
  den.aspects.desktop = {
    homeManager = {
      home.file."Pictures/Wallpapers" = {
        source = inputs.wallpapers;
        recursive = true;
      };
    };
  };
}
