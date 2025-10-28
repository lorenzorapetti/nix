{lib, ...}: config: let
  inherit (config.lib.file) mkOutOfStoreSymlink;

  dotfilesPath = "${config.home.homeDirectory}/nix/dotfiles";
  toSrcFile = name: "${dotfilesPath}/${name}";
  link = name: mkOutOfStoreSymlink (toSrcFile name);

  linkFile = name: {
    ${name}.source = link name;
  };
  linkDir = name: {
    ${name} = {
      source = link name;
      recursive = true;
    };
  };
in {
  linkConfFiles = lib.map linkFile;
  linkConfDirs = lib.map linkDir;
}
