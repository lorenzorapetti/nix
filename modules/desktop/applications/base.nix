{den, ...}: let
  imvMimeTypes = [
    "image/png"
    "image/jpeg"
    "image/jpg"
    "image/gif"
    "image/bmp"
    "image/webp"
    "image/tiff"
    "image/x-xcf"
    "image/x-portable-pixmap"
    "image/x-xbitmap"
  ];
in {
  # Absolutely necessary apps for every machine
  den.aspects.desktop.base-applications = {
    includes = with den.aspects; [
      desktop._1password
    ];

    nixos = {
      pkgs,
      inputs',
      ...
    }: {
      environment.systemPackages = with pkgs; [
        # Browsers
        firefox
        inputs'.helium.packages.default

        ticktick
        cine # Video player

        libreoffice-stable
        streamcontroller
      ];

      programs.obs-studio.enable = true;
      programs.thunderbird.enable = true;
      programs.evince.enable = true;

      # Ports for KDE Connect
      networking.firewall = rec {
        allowedTCPPortRanges = [
          {
            from = 1714;
            to = 1764;
          }
        ];
        allowedUDPPortRanges = allowedTCPPortRanges;
      };
    };

    homeManager = {
      xdg.desktopEntries.imv = {
        name = "Image Viewer";
        exec = "imv %F";
        icon = "imv";
        type = "Application";
        mimeType = imvMimeTypes;
        terminal = false;
        categories = ["Graphics" "Viewer"];
      };

      programs = {
        imv = {
          enable = true;
          settings = {
            aliases = {
              x = "close";
            };

            binds = {
              "<Ctrl+y>" = "exec wl-copy < \"$imv_current_file\"";
              y = "exec wl-copy \"$imv_current_file\"";
            };
          };
        };

        mpv = {
          enable = true;
        };

        obsidian = {
          enable = true;
          cli.enable = true;
        };
      };

      services.kdeconnect = {
        enable = true;
        indicator = true;
      };

      services.nextcloud-client = {
        enable = true;
        startInBackground = true;
      };
    };

    mimeApps = [
      {
        mimes = [
          "video/mp4"
          "video/x-matroska"
          "video/x-msvideo"
          "video/webm"
          "video/quicktime"
          "video/x-flv"
          "video/x-ms-wmv"
          "video/mpeg"
          "video/ogg"
        ];
        app = "io.github.diegopvlk.Cine.desktop";
      }
      {
        mimes = imvMimeTypes;
        app = "imv.desktop";
      }
      {
        mimes = [
          "application/pdf"
          "application/x-pdf"
          "application/vnd.pdf"
          "application/x-bzpdf"
        ];
        app = "org.gnome.Evince.desktop";
      }
    ];
  };
}
