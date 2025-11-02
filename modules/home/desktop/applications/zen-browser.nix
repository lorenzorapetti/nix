{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.programs.zen-browser;
in {
  config = {
    programs.zen-browser = mkIf cfg.enable {
      nativeMessagingHosts = [pkgs._1password-gui];

      policies = let
        mkLockedAttrs = builtins.mapAttrs (_: value: {
          Value = value;
          Status = "locked";
        });

        mkPluginUrl = id: "https://addons.mozilla.org/firefox/downloads/latest/${id}/latest.xpi";

        mkExtensionEntry = {
          id,
          pinned ? false,
          privateBrowsing ? false,
        }: let
          base = {
            install_url = mkPluginUrl id;
            installation_mode = "force_installed";
            private_browsing = privateBrowsing;
          };
        in
          if pinned
          then base // {default_area = "navbar";}
          else base;

        mkExtensionSettings = builtins.mapAttrs (_: entry:
          if builtins.isAttrs entry
          then entry
          else mkExtensionEntry {id = entry;});
      in {
        AutofillAddressEnabled = false;
        AutofillCreditCardEnabled = false;
        DisableAppUpdate = true;
        DisableFeedbackCommands = true;
        DisableFirefoxStudies = true;
        DisableProfileImport = true;
        DisableTelemetry = true;
        DontCheckDefaultBrowser = true;
        NoDefaultBookmarks = true;
        OfferToSaveLogins = false;
        GenerativeAI = {
          Enabled = false;
        };

        ExtensionSettings = mkExtensionSettings {
          "{d634138d-c276-4fc8-924b-40a0ea21d284}" = mkExtensionEntry {
            id = "1password-x-password-manager";
            pinned = true;
            privateBrowsing = true;
          };
          "jid0-adyhmvsP91nUO8pRv0Mn2VKeB84@jetpack" = mkExtensionEntry {
            id = "raindropio";
            pinned = true;
          };
          "uBlock0@raymondhill.net" = mkExtensionEntry {
            id = "ublock-origin";
            privateBrowsing = true;
          };
          "idcac-pub@guus.ninja" = mkExtensionEntry {
            id = "istilldontcareaboutcookies";
            privateBrowsing = true;
          };
          "addon@darkreader.org" = "darkreader";
          "wappalyzer@crunchlabz.com" = "wappalyzer";
          "{1be309c5-3e4f-4b99-927d-bb500eb4fa88}" = "augmented-steam";
          "{b5dd9324-33b6-4ef0-81b6-97496dd6e81d}" = "instant-gaming";
          "amptra@keepa.com" = "keepa";
          "@react-devtools" = "react-devtools";
          "{a4c4eda4-fb84-4a84-b4a1-f7c1cbf2a1ad}" = "refined-github-";
          "sponsorBlocker@ajay.app" = "sponsorblock";
          "firefox@tampermonkey.net" = "get-tamper-monkey";
          "{d7742d87-e61d-4b78-b8a1-b469842139fa}" = "vimium-ff";
          "{85860b32-02a8-431a-b2b1-40fbd64c9c69}" = "github-file-icons";
          "github-no-more@ihatereality.space" = "github-no-more";
          "github-repository-size@pranavmangal" = "gh-repo-size";
          "firefox-extension@steamdb.info" = "steam-database";
          "{861a3982-bb3b-49c6-bc17-4f50de104da1}" = "custom-user-agent-revived";
        };

        Preferences = mkLockedAttrs {
          "browser.aboutConfig.showWarning" = false;
          "browser.tabs.warnOnClose" = false;
          "media.videocontrols.picture-in-picture.video-toggle.enabled" = true;
          "zen.workspaces.separate-essentials" = true;
        };
      };

      profiles.default = rec {
        containersForce = true;
        containers = {
          Work = {
            color = "orange";
            icon = "briefcase";
            id = 2;
          };
        };

        spacesForce = true;
        spaces = {
          "Home" = {
            id = "b731e473-0ab9-410f-aa9c-8372f54ae2b8";
            icon = "🏠";
            position = 1000;
            theme = {
              type = "gradient";
              colors = [
                {
                  red = 102;
                  green = 138;
                  blue = 204;
                  custom = false;
                  algorithm = "analogous";
                  lightness = 60;
                  position.x = 110;
                  position.y = 124;
                  type = "explicit-lightness";
                }
                {
                  red = 135;
                  green = 100;
                  blue = 206;
                  custom = false;
                  algorithm = "analogous";
                  lightness = 60;
                  position.x = 166;
                  position.y = 95;
                  type = "explicit-lightness";
                }
                {
                  red = 98;
                  green = 208;
                  blue = 203;
                  custom = false;
                  algorithm = "analogous";
                  lightness = 60;
                  position.x = 96;
                  position.y = 185;
                  type = "explicit-lightness";
                }
              ];
              opacity = 0.491;
            };
          };
          "Homelab" = {
            id = "6b7b9522-5e9a-4342-a106-aaf81b8cec3f";
            icon = "🖥️";
            position = 2000;
            theme = {
              type = "gradient";
              colors = [
                {
                  red = 76;
                  green = 52;
                  blue = 70;
                  custom = false;
                  algorithm = "complementary";
                  lightness = 25;
                  position.x = 284;
                  position.y = 74;
                  type = "explicit-lightness";
                }
                {
                  red = 53;
                  green = 75;
                  blue = 63;
                  custom = false;
                  algorithm = "complementary";
                  lightness = 25;
                  position.x = 54;
                  position.y = 265;
                  type = "explicit-lightness";
                }
              ];
              opacity = 0.801;
            };
          };
          "Work" = {
            id = "10cf1440-7384-449e-9741-9d44675836b5";
            icon = "🧑‍💻";
            position = 3000;
            container = containers."Work".id;
            theme = {
              type = "gradient";
              colors = [
                {
                  red = 54;
                  green = 99;
                  blue = 68;
                  custom = false;
                  algorithm = "floating";
                  lightness = 30;
                  position.x = 84;
                  position.y = 268;
                  type = "explicit-lightness";
                }
              ];
              opacity = 0.801;
            };
          };
        };

        pinsForce = true;
        pins = {
          "GitHub" = {
            id = "48e8a119-5a14-4826-9545-91c8e8dd3bf6";
            url = "https://github.com";
            position = 101;
            isEssential = true;
          };
          "Reddit" = {
            id = "f65fe7dd-b0bc-4421-8f18-35df6c53c147";
            url = "https://reddit.com";
            position = 102;
            isEssential = true;
          };
          "X" = {
            id = "f3e540d8-7f90-4ebb-afcb-2d7b55a7e93b";
            url = "https://x.com";
            position = 103;
            isEssential = true;
          };
          "YouTube" = {
            id = "c33ff83c-f50f-43e3-8e19-1be808742e2f";
            url = "https://youtube.com";
            position = 104;
            isEssential = true;
          };
          "Amazon" = {
            id = "25003537-577d-43c8-a24b-bb6338e8c9e6";
            url = "https://amazon.it";
            position = 105;
            isEssential = true;
          };
          "ChatGPT" = {
            id = "16a3a5fc-d524-44d5-a491-e5c4d0986fab";
            url = "https://chatgpt.com";
            position = 106;
            isEssential = true;
          };

          "Proton Mail" = {
            id = "3d79570e-deac-4e9d-9776-4ca660e0943c";
            url = "https://mail.proton.me/u/0/inbox";
            position = 107;
            workspace = spaces."Home".id;
            title = "Proton Mail";
            editedTitle = true;
          };
          "Fastmail" = {
            id = "2bbfc12c-6dcc-4632-80e1-1e41b69e46b7";
            url = "https://app.fastmail.com/mail/Inbox";
            position = 108;
            workspace = spaces."Home".id;
            title = "Fastmail";
            editedTitle = true;
          };

          "Stores" = {
            id = "9615716f-451e-4435-bc98-7d2e1d1adc33";
            position = 200;
            workspace = spaces."Homelab".id;
            isGroup = true;
            title = "Stores";
            editedTitle = true;
            isFolderCollapsed = true;
          };
          "Density" = {
            id = "1bdef2a0-e8d3-4fec-bbc9-74d3e7bb9c4c";
            position = 201;
            workspace = spaces."Homelab".id;
            url = "https://www.density.sk/shop/";
            title = "Density";
            editedTitle = true;
            folderParentId = pins."Stores".id;
          };
          "Datablocks" = {
            id = "a4fb1f7f-f5b8-48ca-bf07-fc4d5488909f";
            position = 202;
            workspace = spaces."Homelab".id;
            url = "https://datablocks.dev";
            title = "Datablocks";
            editedTitle = true;
            folderParentId = pins."Stores".id;
          };

          "Services" = {
            id = "c6f30e81-4531-4cb4-a1a9-c0936b84e4c6";
            position = 203;
            workspace = spaces."Homelab".id;
            isGroup = true;
            title = "Services";
            editedTitle = true;
            isFolderCollapsed = true;
          };
          "Paperless" = {
            id = "681f9a62-6641-4e06-b5c8-f11e90f32fdb";
            position = 204;
            workspace = spaces."Homelab".id;
            url = "https://documents.lorenzorapetti.com/dashboard";
            title = "Paperless-ngx";
            editedTitle = true;
            folderParentId = pins."Services".id;
          };

          "Proxmox" = {
            id = "4704b280-970b-4dbe-83f7-ac1c82e569b4";
            position = 205;
            workspace = spaces."Homelab".id;
            isGroup = true;
            title = "Proxmox";
            editedTitle = true;
            isFolderCollapsed = true;
          };
          "ProxmoxService" = {
            id = "23b0c954-525d-46ad-be25-7d97777b013c";
            position = 206;
            workspace = spaces."Homelab".id;
            url = "https://asgard.lorenzolab.com:8006";
            title = "Proxmox";
            editedTitle = true;
            folderParentId = pins."Proxmox".id;
          };
          "PBS" = {
            id = "96126547-c0a2-4ae7-b8da-21c15da7e9c5";
            position = 207;
            workspace = spaces."Homelab".id;
            url = "https://pbs.asgard.lorenzolab.com:8007";
            title = "PBS";
            editedTitle = true;
            folderParentId = pins."Proxmox".id;
          };
          "ProxmoxScripts" = {
            id = "03c3ef8d-a386-45db-9620-a7c45c0e272b";
            position = 208;
            workspace = spaces."Homelab".id;
            url = "https://community-scripts.github.io/ProxmoxVE/";
            title = "Proxmox Helper Scripts";
            editedTitle = true;
            folderParentId = pins."Proxmox".id;
          };

          "Glances" = {
            id = "7ff919f6-e8d4-4533-bf31-69bd523988d8";
            position = 209;
            workspace = spaces."Homelab".id;
            url = "https://home.lorenzolab.com";
            title = "Home";
            editedTitle = true;
          };
          "Gitea" = {
            id = "b555424a-8688-4938-aa27-7588ae4b45a3";
            position = 210;
            workspace = spaces."Homelab".id;
            url = "https://git.lorenzolab.com";
            title = "Gitea";
            editedTitle = true;
          };
        };

        search = {
          force = true;
          default = "ecosia";
          engines = let
            nixSnowflakeIcon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          in {
            "Nix Packages" = {
              urls = [
                {
                  template = "https://search.nixos.org/packages";
                  params = [
                    {
                      name = "type";
                      value = "packages";
                    }
                    {
                      name = "channel";
                      value = "unstable";
                    }
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              icon = nixSnowflakeIcon;
              definedAliases = ["np"];
            };
            "Nix Options" = {
              urls = [
                {
                  template = "https://search.nixos.org/options";
                  params = [
                    {
                      name = "channel";
                      value = "unstable";
                    }
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              icon = nixSnowflakeIcon;
              definedAliases = ["nop"];
            };
            "Home Manager Options" = {
              urls = [
                {
                  template = "https://home-manager-options.extranix.com/";
                  params = [
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                    {
                      name = "release";
                      value = "master"; # unstable
                    }
                  ];
                }
              ];
              icon = nixSnowflakeIcon;
              definedAliases = ["hmop"];
            };
            bing.metaData.hidden = "true";
          };
        };
      };
    };
  };
}
