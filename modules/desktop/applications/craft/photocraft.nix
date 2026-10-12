{
  perSystem = {
    pkgs,
    system,
    lib,
    ...
  }: {
    packages = import ../../../_lib/appimage.nix {inherit pkgs lib system;} rec {
      pname = "photocraft";
      version = "0.6.0";
      appId = "ai.storyteller.photocraft";

      sources = {
        x86_64-linux = {
          url = "https://github.com/storytold/photocraft/releases/download/v${version}/photocraft-${version}-linux-x86_64.AppImage";
          hash = "sha256-Y1+TiT+Unb8Xorwg4cKFqO/byIWchErS+6ro5wCfZ9Y=";
        };
        aarch64-linux = {
          url = "https://github.com/storytold/photocraft/releases/download/v${version}/photocraft-${version}-linux-aarch64.AppImage";
          hash = "sha256-1YgB51b+jjsWWWgA1t5J6Hb35lP45obEyUiD4mCDAVQ=";
        };
      };

      meta = {
        description = "Open-source, clean-room reimplementation of Adobe Photoshop built in Rust";
        homepage = "https://github.com/storytold/photocraft";
        downloadPage = "https://github.com/storytold/photocraft/releases";
        changelog = "https://github.com/storytold/photocraft/releases/tag/v${version}";
        license = lib.licenses.asl20;
      };
    };
  };

  den.aspects.desktop.base-applications = {
    homeManager = {self', ...}: {
      home.packages = [self'.packages.photocraft];
    };

    mimeApps = [
      {
        # Upstream's .desktop also claims common image formats (png, jpeg,
        # webp, ...); leave those to imv and only take the editor formats.
        mimes = [
          "application/x-photocraft"
          "image/x-paintnet"
          "image/vnd.adobe.photoshop"
          "image/x-psd"
          "image/x-psb"
        ];
        app = "ai.storyteller.photocraft.desktop";
      }
    ];
  };
}
