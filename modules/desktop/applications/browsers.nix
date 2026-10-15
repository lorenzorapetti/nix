{inputs, ...}: {
  den.aspects.desktop.base-applications = {
    nixos = {pkgs, ...}: {
      nixpkgs.overlays = [
        inputs.helium.overlays.default
        (_final: prev: {
          helium = prev.helium.overrideAttrs (old: {
            # Chromium keeps VA-API video encode off by default on Linux.
            postFixup =
              (old.postFixup or "")
              + ''
                substituteInPlace $out/bin/helium \
                  --replace-fail "--enable-features=WaylandWindowDecorations" \
                    "--enable-features=WaylandWindowDecorations,AcceleratedVideoEncoder"
              '';
          });
        })
      ];

      environment.systemPackages = with pkgs; [
        firefox
        helium
      ];
    };

    homeManager = {pkgs, ...}: {
      imports = [inputs.zen-browser.homeModules.beta];

      programs.zen-browser = {
        enable = true;
        profiles.default = {
          presets.betterfox.enable = true;

          search = {
            force = true;
            default = "ecosia";
            engines = {
              mynixos = {
                name = "My NixOS";
                urls = [
                  {
                    template = "https://mynixos.com/search?q={searchTerms}";
                    params = [
                      {
                        name = "query";
                        value = "searchTerms";
                      }
                    ];
                  }
                ];
                icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                definedAliases = ["n"];
              };
              github = {
                name = "GitHub Search";
                urls = [
                  {
                    template = "https://github.com/search?q={searchTerms}";
                  }
                ];
                definedAliases = ["g"];
              };
            };
          };
        };

        policies = {
          AutofillAddressEnabled = true;
          AutofillCreditCardEnabled = false;
          DisableAppUpdate = true;
          DisableFeedbackCommands = true;
          DisableFirefoxStudies = true;
          DisablePocket = true;
          DisableTelemetry = true;
          DontCheckDefaultBrowser = true;
          NoDefaultBookmarks = true;
          OfferToSaveLogins = false;
          EnableTrackingProtection = {
            Value = true;
            Locked = true;
            Cryptomining = true;
            Fingerprinting = true;
          };
        };
      };
    };

    mimeApps = [
      {
        mimes = ["text/html" "text/xml" "application/xhtml+xml" "x-scheme-handler/http" "x-scheme-handler/https"];
        app = "helium.desktop";
      }
    ];
  };
}
