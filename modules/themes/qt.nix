{
  den.aspects.theming.base = {
    homeManager = {
      pkgs,
      lib,
      config,
      osConfig,
      ...
    }: let
      KvLibadwaita = pkgs.fetchFromGitHub {
        owner = "GabePoel";
        repo = "KvLibadwaita";
        rev = "1f4e0bec44b13dabfa1fe4047aa8eeaccf2f3557";
        hash = "sha256-32RlnRBNJajD0Ps+vZSwVfDj6HzPpZjfm/LBG7u0eDg=";
        sparseCheckout = ["src"];
      };
    in {
      home = {
        sessionVariables = {
          QT_QPA_PLATFORMTHEME = lib.mkForce "qt6ct";
          QT_STYLE_OVERRIDE = lib.mkForce null;
        };
      };

      # home-manager's qt module also writes QT_STYLE_OVERRIDE into
      # systemd.user.sessionVariables (environment.d), independently of
      # home.sessionVariables above; both must be overridden to suppress it.
      systemd.user.sessionVariables.QT_STYLE_OVERRIDE = lib.mkForce "";

      qt = let
        default = ''"${osConfig.fonts.sans},10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1,Regular"'';
        qtctSettings = {
          Appearance = {
            color_scheme_path = "/home/${config.home.username}/.config/qt6ct/style-colors.conf";
            custom_palette = true;
            icon_theme = "Adwaita";
            standard_dialogs = "xdgdesktopportal";
            style = "kvantum";
          };
          Fonts = {
            fixed = default;
            general = default;
          };
        };
      in {
        enable = true;
        kvantum.enable = true;
        style.name = "kvantum";
        platformTheme.name = "qtct";

        kvantum.settings = {
          General = {
            theme = "KvLibadwaitaDark";
          };
        };

        qt6ctSettings = qtctSettings;
        qt5ctSettings = qtctSettings;

        # KDE Frameworks/Kirigami apps (e.g. KDE Connect) don't consult
        # qt6ct/Kvantum at all — they read kdeglobals directly. These are
        # transcribed from KvLibadwaita's own "Libadwaita Dark.colors" KDE
        # color scheme (src/Colors/Libadwaita Dark.colors, pinned rev above)
        # so KDE apps match the Kvantum theme instead of falling back to
        # Breeze; kept as a literal copy rather than reaching for
        # plasma-apply-colorscheme, which requires depending on the whole
        # plasma-workspace closure (+~700MB) for one binary.
        kde.settings.kdeglobals = {
          KDE = {
            widgetStyle = "kvantum";
            contrast = "4";
          };

          General = {
            ColorScheme = "LibadwaitaDark";
            Name = "LibadwaitaDark";
            shadeSortColumn = true;
          };

          "ColorEffects:Disabled" = {
            Color = "255,255,255";
            ColorAmount = "0";
            ColorEffect = "0";
            ContrastAmount = "0.65";
            ContrastEffect = "1";
            IntensityAmount = "0.1";
            IntensityEffect = "2";
          };

          "ColorEffects:Inactive" = {
            ChangeSelectionColor = true;
            Color = "255,255,255";
            ColorAmount = "0.025";
            ColorEffect = "2";
            ContrastAmount = "0.1";
            ContrastEffect = "2";
            Enable = false;
            IntensityAmount = "0";
            IntensityEffect = "0";
          };

          "Colors:Button" = {
            BackgroundAlternate = "68,68,68";
            BackgroundNormal = "58,58,58";
            DecorationFocus = "120,174,237";
            DecorationHover = "53,132,228";
            ForegroundActive = "53,132,228";
            ForegroundInactive = "102,102,102";
            ForegroundLink = "120,174,237";
            ForegroundNegative = "255,123,99";
            ForegroundNeutral = "248,228,92";
            ForegroundNormal = "255,255,255";
            ForegroundPositive = "143,240,164";
            ForegroundVisited = "179,179,179";
          };

          "Colors:Complementary" = {
            BackgroundAlternate = "42,42,42";
            BackgroundNormal = "39,39,39";
            DecorationFocus = "120,174,237";
            DecorationHover = "53,132,228";
            ForegroundActive = "53,132,228";
            ForegroundInactive = "102,102,102";
            ForegroundLink = "120,174,237";
            ForegroundNegative = "255,123,99";
            ForegroundNeutral = "248,228,92";
            ForegroundNormal = "255,255,255";
            ForegroundPositive = "143,240,164";
            ForegroundVisited = "179,179,179";
          };

          "Colors:Header" = {
            BackgroundAlternate = "36,36,36";
            BackgroundNormal = "48,48,48";
            DecorationFocus = "120,174,237";
            DecorationHover = "53,132,228";
            ForegroundActive = "255,255,255";
            ForegroundInactive = "102,102,102";
            ForegroundLink = "120,174,237";
            ForegroundNegative = "255,123,99";
            ForegroundNeutral = "248,228,92";
            ForegroundNormal = "255,255,255";
            ForegroundPositive = "143,240,164";
            ForegroundVisited = "179,179,179";

            Inactive = {
              BackgroundAlternate = "36,36,36";
              BackgroundNormal = "36,36,36";
              DecorationFocus = "120,174,237";
              DecorationHover = "53,132,228";
              ForegroundActive = "102,102,102";
              ForegroundInactive = "102,102,102";
              ForegroundLink = "120,174,237";
              ForegroundNegative = "255,123,99";
              ForegroundNeutral = "248,228,92";
              ForegroundNormal = "102,102,102";
              ForegroundPositive = "143,240,164";
              ForegroundVisited = "179,179,179";
            };
          };

          "Colors:Selection" = {
            BackgroundAlternate = "53,132,228";
            BackgroundNormal = "53,132,228";
            DecorationFocus = "120,174,237";
            DecorationHover = "53,132,228";
            ForegroundActive = "53,132,228";
            ForegroundInactive = "102,102,102";
            ForegroundLink = "120,174,237";
            ForegroundNegative = "255,123,99";
            ForegroundNeutral = "248,228,92";
            ForegroundNormal = "255,255,255";
            ForegroundPositive = "143,240,164";
            ForegroundVisited = "179,179,179";
          };

          "Colors:Tooltip" = {
            BackgroundAlternate = "30,30,30";
            BackgroundNormal = "30,30,30";
            DecorationFocus = "120,174,237";
            DecorationHover = "53,132,228";
            ForegroundActive = "255,255,255";
            ForegroundInactive = "255,255,255";
            ForegroundLink = "255,255,255";
            ForegroundNegative = "255,255,255";
            ForegroundNeutral = "255,255,255";
            ForegroundNormal = "255,255,255";
            ForegroundPositive = "255,255,255";
            ForegroundVisited = "255,255,255";
          };

          "Colors:View" = {
            BackgroundAlternate = "39,39,39";
            BackgroundNormal = "42,42,42";
            DecorationFocus = "120,174,237";
            DecorationHover = "53,132,228";
            ForegroundActive = "53,132,228";
            ForegroundInactive = "102,102,102";
            ForegroundLink = "120,174,237";
            ForegroundNegative = "255,123,99";
            ForegroundNeutral = "248,228,92";
            ForegroundNormal = "255,255,255";
            ForegroundPositive = "143,240,164";
            ForegroundVisited = "179,179,179";
          };

          "Colors:Window" = {
            BackgroundAlternate = "36,36,36";
            BackgroundNormal = "36,36,36";
            DecorationFocus = "120,174,237";
            DecorationHover = "53,132,228";
            ForegroundActive = "53,132,228";
            ForegroundInactive = "102,102,102";
            ForegroundLink = "120,174,237";
            ForegroundNegative = "255,123,99";
            ForegroundNeutral = "248,228,92";
            ForegroundNormal = "255,255,255";
            ForegroundPositive = "143,240,164";
            ForegroundVisited = "179,179,179";
          };

          WM = {
            activeBackground = "36,36,36";
            activeBlend = "102,102,102";
            activeForeground = "255,255,255";
            inactiveBackground = "36,36,36";
            inactiveBlend = "102,102,102";
            inactiveForeground = "255,255,255";
          };
        };
      };

      xdg.configFile = {
        # Kvantum requires each theme's config dir to be named after the theme
        # itself (<name>/<name>.kvconfig); KvLibadwaita ships both variants
        # inside one "KvLibadwaita" folder, so map each name explicitly.
        "Kvantum/KvLibadwaita" = {
          source = "${KvLibadwaita}/src/KvLibadwaita";
          recursive = true;
        };
        "Kvantum/KvLibadwaitaDark" = {
          source = "${KvLibadwaita}/src/KvLibadwaita";
          recursive = true;
        };
        "Kvantum/Colors" = {
          source = "${KvLibadwaita}/src/Colors";
          recursive = true;
        };
      };
    };
  };
}
