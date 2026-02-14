{...}: {
  programs.dank-material-shell.settings = {
    currentThemeName = "blue";
    currentThemeCategory = "generic";
    customThemeFile = "";
    registryThemeVariants = {};
    matugenScheme = "scheme-tonal-spot";
    runUserMatugenTemplates = true;
    matugenTargetMonitor = "";
    popupTransparency = 1;
    dockTransparency = 1;
    widgetBackgroundColor = "sch";
    widgetColorMode = "default";
    cornerRadius = 10;
    use24HourClock = true;
    showSeconds = false;
    useFahrenheit = false;
    nightModeEnabled = false;
    animationSpeed = 4;
    customAnimationDuration = 201;
    wallpaperFillMode = "Fill";
    blurredWallpaperLayer = false;
    blurWallpaperOnOverview = true;
    showLauncherButton = true;
    showWorkspaceSwitcher = true;
    showFocusedWindow = true;
    showWeather = true;
    showMusic = false;
    showClipboard = true;
    showCpuUsage = true;
    showMemUsage = true;
    showCpuTemp = true;
    showGpuTemp = true;
    selectedGpuIndex = 0;
    enabledGpuPciIds = [];
    showSystemTray = true;
    showClock = true;
    showNotificationButton = true;
    showBattery = false;
    showControlCenterButton = true;
    showCapsLockIndicator = true;
    controlCenterShowNetworkIcon = true;
    controlCenterShowBluetoothIcon = true;
    controlCenterShowAudioIcon = true;
    controlCenterShowAudioPercent = false;
    controlCenterShowVpnIcon = true;
    controlCenterShowBrightnessIcon = false;
    controlCenterShowBrightnessPercent = false;
    controlCenterShowMicIcon = false;
    controlCenterShowMicPercent = false;
    controlCenterShowBatteryIcon = false;
    controlCenterShowPrinterIcon = false;
    controlCenterShowScreenSharingIcon = true;
    showPrivacyButton = true;
    privacyShowMicIcon = false;
    privacyShowCameraIcon = false;
    privacyShowScreenShareIcon = false;
    controlCenterWidgets = [
      {
        id = "volumeSlider";
        enabled = true;
        width = 50;
      }
      {
        id = "brightnessSlider";
        enabled = true;
        width = 50;
      }
      {
        id = "wifi";
        enabled = true;
        width = 50;
      }
      {
        id = "bluetooth";
        enabled = true;
        width = 50;
      }
      {
        id = "audioOutput";
        enabled = true;
        width = 50;
      }
      {
        id = "audioInput";
        enabled = true;
        width = 50;
      }
      {
        id = "nightMode";
        enabled = true;
        width = 50;
      }
      {
        id = "darkMode";
        enabled = true;
        width = 50;
      }
      {
        id = "idleInhibitor";
        enabled = true;
        width = 25;
      }
      {
        id = "builtin_vpn";
        enabled = true;
        width = 50;
      }
      {
        id = "colorPicker";
        enabled = true;
        width = 25;
      }
    ];
    showWorkspaceIndex = false;
    showWorkspaceName = false;
    showWorkspacePadding = false;
    workspaceScrolling = false;
    showWorkspaceApps = false;
    maxWorkspaceIcons = 3;
    groupWorkspaceApps = true;
    workspaceFollowFocus = false;
    showOccupiedWorkspacesOnly = false;
    reverseScrolling = false;
    dwlShowAllTags = false;
    workspaceColorMode = "default";
    workspaceUnfocusedColorMode = "default";
    workspaceUrgentColorMode = "default";
    workspaceFocusedBorderEnabled = false;
    workspaceFocusedBorderColor = "primary";
    workspaceFocusedBorderThickness = 2;
    workspaceNameIcons = {};
    waveProgressEnabled = true;
    scrollTitleEnabled = true;
    audioVisualizerEnabled = true;
    audioScrollMode = "volume";
    clockCompactMode = false;
    focusedWindowCompactMode = false;
    runningAppsCompactMode = true;
    keyboardLayoutNameCompactMode = false;
    runningAppsCurrentWorkspace = false;
    runningAppsGroupByApp = false;
    appIdSubstitutions = [
      {
        pattern = "Spotify";
        replacement = "spotify";
        type = "exact";
      }
      {
        pattern = "beepertexts";
        replacement = "beeper";
        type = "exact";
      }
      {
        pattern = "home assistant desktop";
        replacement = "homeassistant-desktop";
        type = "exact";
      }
      {
        pattern = "com.transmissionbt.transmission";
        replacement = "transmission-gtk";
        type = "contains";
      }
      {
        pattern = "^steam_app_(\\d+)$";
        replacement = "steam_icon_$1";
        type = "regex";
      }
    ];
    centeringMode = "index";
    clockDateFormat = "";
    lockDateFormat = "";
    mediaSize = 1;
    appLauncherViewMode = "grid";
    spotlightModalViewMode = "list";
    sortAppsAlphabetically = false;
    appLauncherGridColumns = 4;
    spotlightCloseNiriOverview = true;
    niriOverviewOverlayEnabled = true;
    useAutoLocation = false;
    weatherEnabled = true;
    networkPreference = "auto";
    vpnLastConnected = "";
    iconTheme = "System Default";
    launcherLogoMode = "apps";
    launcherLogoCustomPath = "";
    launcherLogoColorOverride = "";
    launcherLogoColorInvertOnMode = false;
    launcherLogoBrightness = 0.5;
    launcherLogoContrast = 1;
    launcherLogoSizeffset = 0;
    fontFamily = "Inter Variable";
    monoFontFamily = "Fira Code";
    fontWeight = 400;
    fontScale = 1;
    notepadUseMonospace = true;
    notepadFontFamily = "";
    notepadFontSize = 14;
    notepadShowLineNumbers = false;
    soundsEnabled = true;
    useSystemSoundTheme = false;
    soundNewNotification = true;
    soundVolumeChanged = true;
    soundPluggedIn = true;
    acMonitorTimeout = 600;
    acLockTimeout = 300;
    acSuspendTimeout = 1800;
    acSuspendBehavior = 2;
    acProfileName = "";
    batteryMonitorTimeout = 0;
    batteryLockTimeout = 0;
    batterySuspendTimeout = 0;
    batterySuspendBehavior = 0;
    batteryProfileName = "";
    batteryChargeLimit = 100;
    lockBeforeSuspend = false;
    loginctlLockIntegration = true;
    fadeToLockEnabled = true;
    fadeToLockGracePeriod = 5;
    fadeToDpmsEnabled = true;
    fadeToDpmsGracePeriod = 5;
    launchPrefix = "";
    brightnessDevicePins = {};
    wifiNetworkPins = {};
    bluetoothDevicePins = {};
    audioInputDevicePins = {};
    audioOutputDevicePins = {};
    gtkThemingEnabled = false;
    qtThemingEnabled = false;
    syncModeWithPortal = true;
    terminalsAlwaysDark = false;
    runDmsMatugenTemplates = true;
    matugenTemplateGtk = true;
    matugenTemplateNiri = true;
    matugenTemplateHyprland = true;
    matugenTemplateMangowc = true;
    matugenTemplateQt5ct = true;
    matugenTemplateQt6ct = true;
    matugenTemplateFirefox = true;
    matugenTemplatePywalfox = true;
    matugenTemplateZenBrowser = true;
    matugenTemplateVesktop = true;
    matugenTemplateEquibop = true;
    matugenTemplateGhostty = true;
    matugenTemplateKitty = true;
    matugenTemplateFoot = true;
    matugenTemplateAlacritty = true;
    matugenTemplateNeovim = true;
    matugenTemplateWezterm = true;
    matugenTemplateDgop = true;
    matugenTemplateKcolorscheme = true;
    matugenTemplateVscode = true;
    showDock = false;
    dockAutoHide = false;
    dockGroupByApp = false;
    dockOpenOnOverview = false;
    dockPosition = 1;
    dockSpacing = 4;
    dockBottomGap = 0;
    dockMargin = 0;
    dockIconSize = 40;
    dockIndicatorStyle = "circle";
    dockBorderEnabled = false;
    dockBorderColor = "surfaceText";
    dockBorderOpacity = 1;
    dockBorderThickness = 1;
    dockIsolateDisplays = false;
    notificationOverlayEnabled = false;
    modalDarkenBackground = true;
    lockScreenShowPowerActions = true;
    lockScreenShowSystemIcons = true;
    lockScreenShowTime = true;
    lockScreenShowDate = true;
    lockScreenShowProfileImage = true;
    lockScreenShowPasswordField = true;
    enableFprint = false;
    maxFprintTries = 15;
    lockScreenActiveMonitor = "all";
    lockScreenInactiveColor = "#000000";
    lockScreenNotificationMode = 0;
    hideBrightnessSlider = false;
    notificationTimeoutLow = 5000;
    notificationTimeoutNormal = 5000;
    notificationTimeoutCritical = 0;
    notificationCompactMode = false;
    notificationPopupPosition = 0;
    notificationHistoryEnabled = true;
    notificationHistoryMaxCount = 50;
    notificationHistoryMaxAgeDays = 7;
    notificationHistorySaveLow = true;
    notificationHistorySaveNormal = true;
    notificationHistorySaveCritical = true;
    osdAlwaysShowValue = true;
    osdPosition = 5;
    osdVolumeEnabled = true;
    osdMediaVolumeEnabled = true;
    osdBrightnessEnabled = true;
    osdIdleInhibitorEnabled = true;
    osdMicMuteEnabled = true;
    osdCapsLockEnabled = true;
    osdPowerProfileEnabled = false;
    osdAudioOutputEnabled = true;
    powerActionConfirm = true;
    powerActionHoldDuration = 0.5;
    powerMenuActions = [
      "reboot"
      "logout"
      "poweroff"
      "lock"
      "suspend"
      "restart"
    ];
    powerMenuDefaultAction = "logout";
    powerMenuGridLayout = true;
    customPowerActionLock = "";
    customPowerActionLogout = "";
    customPowerActionSuspend = "";
    customPowerActionHibernate = "";
    customPowerActionReboot = "";
    customPowerActionPowerOff = "";
    updaterHideWidget = false;
    updaterUseCustomCommand = false;
    updaterCustomCommand = "";
    updaterTerminalAdditionalParams = "";
    displayNameMode = "system";
    screenPreferences = {};
    showOnLastDisplay = {};
    hyprlandOutputSettings = {};
    barConfigs = [
      {
        id = "default";
        name = "Main Bar";
        enabled = true;
        position = 0;
        screenPreferences = [
          "all"
        ];
        showOnLastDisplay = true;
        leftWidgets = [
          "workspaceSwitcher"
          "focusedWindow"
          {
            id = "privacyIndicator";
            enabled = true;
          }
        ];
        centerWidgets = [
          "music"
          "clock"
          "weather"
        ];
        rightWidgets = [
          {
            id = "systemTray";
            enabled = true;
          }
          {
            id = "clipboard";
            enabled = true;
          }
          {
            id = "vpn";
            enabled = true;
          }
          {
            id = "tailscale";
            enabled = true;
          }
          {
            id = "cpuUsage";
            enabled = true;
          }
          {
            id = "memUsage";
            enabled = true;
          }
          {
            id = "dockerManager";
            enabled = true;
          }
          {
            id = "notificationButton";
            enabled = true;
          }
          {
            id = "controlCenterButton";
            enabled = true;
          }
        ];
        spacing = 4;
        innerPadding = 5;
        bottomGap = -5;
        transparency = 0;
        widgetTransparency = 1;
        squareCorners = false;
        noBackground = false;
        gothCornersEnabled = false;
        gothCornerRadiusOverride = false;
        gothCornerRadiusValue = 12;
        borderEnabled = false;
        borderColor = "surfaceText";
        borderOpacity = 1;
        borderThickness = 1;
        fontScale = 1;
        autoHide = false;
        autoHideDelay = 250;
        openOnOverview = false;
        visible = true;
        popupGapsAuto = true;
        popupGapsManual = 4;
        widgetOutlineEnabled = true;
        widgetOutlineColor = "secondary";
        widgetOutlineThickness = 1;
        widgetOutlineOpacity = 0.3;
        shadowColorMode = "text";
        shadowIntensity = 0;
      }
    ];
    desktopClockEnabled = false;
    desktopClockStyle = "analog";
    desktopClockTransparency = 0.8;
    desktopClockColorMode = "primary";
    desktopClockShowDate = true;
    desktopClockShowAnalogNumbers = false;
    desktopClockShowAnalogSeconds = true;
    desktopClockWidth = 280;
    desktopClockHeight = 180;
    desktopClockDisplayPreferences = [
      "all"
    ];
    systemMonitorEnabled = false;
    systemMonitorShowHeader = true;
    systemMonitorTransparency = 0.8;
    systemMonitorColorMode = "primary";
    systemMonitorShowCpu = true;
    systemMonitorShowCpuGraph = true;
    systemMonitorShowCpuTemp = true;
    systemMonitorShowGpuTemp = false;
    systemMonitorGpuPciId = "";
    systemMonitorShowMemory = true;
    systemMonitorShowMemoryGraph = true;
    systemMonitorShowNetwork = true;
    systemMonitorShowNetworkGraph = true;
    systemMonitorShowDisk = true;
    systemMonitorShowTopProcesses = false;
    systemMonitorTopProcessCount = 3;
    systemMonitorTopProcessSortBy = "cpu";
    systemMonitorGraphInterval = 60;
    systemMonitorLayoutMode = "auto";
    systemMonitorWidth = 320;
    systemMonitorHeight = 480;
    systemMonitorDisplayPreferences = [
      "all"
    ];
    systemMonitorVariants = [];
    desktopWidgetPositions = {};
    desktopWidgetGridSettings = {};
    desktopWidgetInstances = [];
    desktopWidgetGroups = [];
    builtInPluginSettings = {
      dms_settings_search = {
        trigger = "?";
      };
    };
    configVersion = 5;
  };
}
