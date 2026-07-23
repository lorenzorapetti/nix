{lib, ...}: {
  den.default.nixos = {lib, ...}: {
    options.fonts = {
      serif = lib.mkOption {
        type = lib.types.str;
        default = "Noto Serif";
      };
      sans = lib.mkOption {
        type = lib.types.str;
        default = "Noto Sans";
      };
      mono = lib.mkOption {
        type = lib.types.str;
        default = "GeistMono Nerd Font Mono";
      };
      nerd = lib.mkOption {
        type = lib.types.str;
        default = "GeistMono Nerd Font Mono";
      };
      fallbackSerif = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = ["Noto Serif CJK JP"];
      };
      fallbackSans = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = ["Noto Sans CJK JP"];
      };
      fallbackMono = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = ["Noto Sans Mono" "Noto Sans Mono CJK J"];
      };
    };
  };
}
