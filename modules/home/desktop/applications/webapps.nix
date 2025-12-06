{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mapAttrs isString getExe mkOption types;

  webapps = config.programs.webapps;

  mkWebapp = _: {
    name,
    icon,
    url,
  }: {
    inherit name;
    type = "Application";

    icon =
      if isNull icon
      then null
      else if isString icon
      then icon
      else "${pkgs.fetchurl {
        inherit (icon) url sha256;
      }}";

    startupNotify = true;
    terminal = false;
    exec = "${getExe pkgs.ungoogled-chromium} --app=\"${url}\"";

    settings = {
      Version = "1.0";
    };
  };
in {
  config = {
    xdg.desktopEntries = mapAttrs mkWebapp webapps;

    programs.webapps = {
      youtube = {
        name = "YouTube";
        icon = {
          url = "https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/youtube.png";
          sha256 = "sha256-IXEiZv0BxEfja0Rh/4YSRzXEg8iSElLAEfCkNUcDFVI=";
        };
        url = "https://youtube.com";
      };

      claude = {
        name = "claude";
        icon = {
          url = "https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/claude-ai.png";
          sha256 = "sha256-76HQVfcmqUniwXKBC/E5DiaIdUMR0K3oVWA26HwSdfA=";
        };
        url = "https://claude.ai";
      };
    };
  };

  options = {
    programs.webapps = mkOption {
      type = types.attrsOf (types.submodule {
        options = {
          name = mkOption {
            type = types.str;
          };
          url = mkOption {
            type = types.str;
          };
          icon = mkOption {
            type = types.nullOr (types.submodule {
              options = {
                url = mkOption {
                  type = types.str;
                };
                sha256 = mkOption {
                  type = types.str;
                };
              };
            });
            default = null;
          };
        };
      });
      default = {};
    };
  };
}
