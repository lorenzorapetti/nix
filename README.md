# Nix Configuration

A modular, flake-based NixOS and nix-darwin configuration for managing multiple hosts with declarative system and home configurations. This repository uses [numtide's blueprint](https://numtide.github.io/blueprint/main/) to automatically map the folder structure into flake outputs, providing a clean and organized approach to system configuration.

## Features

- **Modular Architecture**: Reusable NixOS, Home Manager, and Darwin modules
- **Multiple Host Support**: Configurations for NixOS and macOS systems
- **Modern Wayland Desktop**: Niri scrolling window manager with complete Wayland stack
- **Unified Theming**: Stylix-based system-wide theming with Catppuccin Mocha
- **Development-Ready**: Pre-configured editors (Helix, Zed, Neovim) with LSP support
- **Power Management**: TLP, thermald, and intelligent power saving
- **Homelab Integration**: Pre-configured browser workspaces for homelab services

## Table of Contents

- [Features](#features)
- [Folder Structure](#folder-structure)
  - [How Blueprint Works](#how-blueprint-works)
- [Hosts](#hosts)
  - [nixps (Primary NixOS System)](#nixps-primary-nixos-system)
  - [mac14 (macOS System)](#mac14-macos-system)
- [Modules](#modules)
  - [NixOS Modules](#nixos-modules-modulesnixos)
    - [Common](#common-nixoscommon)
    - [Desktop](#desktop-nixosdesktop)
    - [Niri Window Manager](#niri-window-manager-nixosniri)
    - [User-Specific](#user-specific-nixoslorenzo)
  - [Home Manager Modules](#home-manager-modules-moduleshome)
    - [Common](#common-homecommon)
    - [Desktop](#desktop-homedesktop)
    - [Desktop-Tiling](#desktop-tiling-homedesktop-tiling)
    - [Niri](#niri-homeniri)
    - [User-Specific](#user-specific-homelorenzo)
  - [Darwin Modules](#darwin-modules-modulesdarwin)
  - [Common Modules](#common-modules-modulescommon)
- [Desktop Environments](#desktop-environments)
  - [Niri Window Manager (Primary)](#niri-window-manager-primary)
  - [Niri Keybindings](#niri-keybindings)
    - [Window Management](#window-management)
    - [Workspaces](#workspaces)
    - [Applications](#applications)
    - [Screenshots](#screenshots)
    - [Media Controls](#media-controls)
    - [System](#system)
- [Adding a New Host](#adding-a-new-host)
  - [Step 1: Create Host Directory](#step-1-create-host-directory)
  - [Step 2: Create Configuration File](#step-2-create-configuration-file)
  - [Step 3: Generate Hardware Configuration](#step-3-generate-hardware-configuration-nixos-only)
  - [Step 4: Create User Home Configuration](#step-4-create-user-home-configuration-optional)
  - [Step 5: Build and Deploy](#step-5-build-and-deploy)
  - [Step 6: Automatic Flake Recognition](#step-6-automatic-flake-recognition)
- [Configuration Options](#configuration-options)
  - [NixOS Module Options](#nixos-module-options)
    - [Common Module Options](#common-module-options)
    - [Desktop Module Options](#desktop-module-options)
    - [Power Management Options](#power-management-options)
    - [Graphics Options](#graphics-options)
  - [Home Manager Module Options](#home-manager-module-options)
    - [Browser Configuration](#browser-configuration)
    - [Editor Configuration](#editor-configuration)
    - [Shell Configuration](#shell-configuration)
    - [Niri Window Manager](#niri-window-manager)
    - [Notification Configuration](#notification-configuration)
    - [Application Launcher](#application-launcher)
- [Key Applications](#key-applications)
  - [Development Tools](#development-tools)
  - [Browsers](#browsers)
  - [Terminal & Shell](#terminal--shell)
  - [System Utilities](#system-utilities)
  - [Media & Communication](#media--communication)
  - [Wayland Tools](#wayland-tools)
- [Development](#development)
  - [Development Shell](#development-shell)
  - [Linting](#linting)
  - [Formatting](#formatting)
  - [Building](#building)
  - [Testing Changes](#testing-changes)
- [Useful Commands](#useful-commands)
  - [System Management](#system-management)
  - [Home Manager](#home-manager)
  - [Niri](#niri)
- [Contributing](#contributing)
- [Resources](#resources)
- [License](#license)

## Folder Structure

This repository follows the blueprint pattern, which automatically maps directories to flake outputs:

```
.
├── flake.nix              # Main flake configuration with inputs
├── flake.lock             # Locked dependencies
├── devshell.nix           # Development shell configuration
├── statix.toml            # Nix linter configuration
│
├── hosts/                 # Host-specific configurations
│   ├── nixps/            # NixOS host configuration
│   │   ├── configuration.nix
│   │   ├── hardware-configuration.nix
│   │   └── users/
│   │       └── lorenzo.nix
│   └── mac14/            # macOS host configuration
│       └── darwin-configuration.nix
│
├── modules/               # Reusable modules
│   ├── nixos/            # NixOS-specific modules
│   │   ├── common/       # Common NixOS configuration
│   │   ├── desktop/      # Desktop environment modules
│   │   ├── niri/         # Niri window manager
│   │   └── lorenzo/      # User-specific NixOS modules
│   ├── home/             # Home Manager modules
│   │   ├── common/       # Common home configuration
│   │   ├── desktop/      # Desktop applications
│   │   ├── desktop-tiling/ # Tiling WM base modules
│   │   ├── niri/         # Niri-specific home config
│   │   └── lorenzo/      # User-specific home modules
│   ├── darwin/           # macOS-specific modules
│   └── common/           # Cross-platform modules
│
├── lib/                   # Custom Nix library functions
│   ├── default.nix       # Main library module
│   ├── link.nix          # File linking utilities
│   └── mimetypes.nix     # MIME type definitions
│
├── packages/              # Custom packages
│   ├── mkScript.nix      # Script creation helper
│   └── screenshot.nix    # Screenshot utility
│
├── dotfiles/              # Application configuration files
│   ├── helix/            # Helix editor config
│   ├── waybar/           # Waybar status bar config
│   └── mpv/              # MPV media player config
│
├── wallpapers/            # System wallpapers
│   └── catppuccin/       # Catppuccin-themed wallpapers
│
└── .helix/                # Project-specific Helix config
```

### How Blueprint Works

Blueprint automatically creates flake outputs based on your directory structure:

- `hosts/nixps/` → `nixosConfigurations.nixps`
- `hosts/mac14/` → `darwinConfigurations.mac14`
- `modules/nixos/common/` → `nixosModules.common`
- `modules/home/desktop/` → `homeModules.desktop`
- `packages/screenshot.nix` → `packages.<system>.screenshot`

This eliminates the need to manually register each configuration in `flake.nix`.

## Hosts

### nixps (Primary NixOS System)

**Hardware:**
- Intel CPU with KVM support
- NVMe SSD with weekly fstrim
- Intel Xe iGPU + Arc GPU support
- IPU6 camera module
- 2560x1600 @ 120Hz display (1.3x scaling)
- Thunderbolt interface

**Key Features:**
- Linux Zen kernel
- systemd-boot bootloader
- ZRAM swap with zstd compression
- Hardware video acceleration (Intel Media Driver + VPL)
- Power management (TLP, thermald)
- Caps Lock to Esc/Ctrl mapping
- Docker (not auto-start)
- Tailscale VPN
- Complete Wayland stack with Niri window manager

**Location:** `hosts/nixps/`

**Modules Imported:**
- `flake.nixosModules.common` - Common NixOS settings
- `flake.nixosModules.niri` - Niri window manager

### mac14 (macOS System)

**Status:** Minimal/placeholder configuration

**Location:** `hosts/mac14/`

## Modules

### NixOS Modules (`modules/nixos/`)

#### Common (`nixos/common/`)
Core NixOS configuration shared across all hosts.

**Modules:**
- `cache.nix` - Binary cache configuration (nixos, niri, nix-community, vicinae)
- `nix.nix` - Nix daemon settings (flakes enabled, auto-gc weekly, auto-optimize)
- `nixpkgs.nix` - Nixpkgs configuration (unfree packages allowed)
- `keyboard.nix` - Caps2Esc keyboard remapping via interception-tools
- `programs.nix` - System-wide packages and programs

**Default Behavior:**
- Docker enabled (not auto-start)
- Caps2Esc enabled by default

**Options:**
- `services.caps2esc.enable` - Enable Caps Lock to Esc/Ctrl mapping (default: true)

**System Packages Included:**
- System monitoring: btop
- Network tools: nmap, tailscale
- Development: gcc, git, wget, curl
- File utilities: archive tools, ripgrep, jq, fzf
- Editors: vim, neovim, helix
- Nix tools: nixd (LSP), alejandra (formatter), statix (linter), cachix, home-manager

#### Desktop (`nixos/desktop/`)
Desktop environment configuration for graphical systems.

**Modules:**
- `stylix.nix` - System-wide theming (Catppuccin Mocha, fonts, cursor)
- `sound.nix` - PipeWire audio with ALSA and Wireplumber
- `bluetooth.nix` - Bluetooth with blueman, auto-enable, experimental features
- `fonts.nix` - Font packages (Nerd Fonts, typography, emoji fonts)
- `sddm.nix` - SDDM display manager with astronaut theme, Wayland support
- `overlays.nix` - Package overlays (Firefox customization, libdisplay-info pin)
- `applications/1password.nix` - 1Password GUI with browser integration
- `applications/default.nix` - Default desktop apps (Nautilus, imv, mpv)

**Options:**
- `services.swayosd.enable` - Enable SwayOSD for volume/brightness control
- `services.awww.enable` - Enable awww wallpaper daemon

**Fonts Included:**
- Nerd Fonts: JetBrains Mono, Geist Mono
- Typography: Fira Sans, Montserrat, Noto Fonts, Open Sans, Roboto, Source Sans Pro
- Emoji: Noto Color Emoji, OpenMoji, Twemoji, Twitter Color Emoji

#### Niri Window Manager (`nixos/niri/`)
Niri scrolling window manager configuration.

**Provides:**
- Niri package with overlay
- SDDM display manager
- Services: udisks2, swayosd, awww
- Systemd services for Wayland components (waybar, hypridle, udiskie, swayosd)
- PolicyKit authentication (gnome-polkit)
- xwayland-satellite for X11 app compatibility

**Location:** `modules/nixos/niri/`

#### User-Specific (`nixos/lorenzo/`)
User-specific system configuration.

**Modules:**
- `language.nix` - Localization (timezone: Europe/Rome, locale: en_US.UTF-8, Italian regional)

### Home Manager Modules (`modules/home/`)

#### Common (`home/common/`)
Shared home configuration for all users.

**Modules:**
- `programs.nix` - Common CLI tools and programs
- `shell/` - Shell configurations (bash, fish, zsh, starship)
- `lazygit.nix` - Git TUI with Catppuccin theme
- `direnv.nix` - Direnv with nix-direnv integration
- `dotfiles.nix` - Symlinks dotfiles to home directory

**Packages Included:**
- CLI tools: fzf, ripgrep, zoxide, lsd, bat
- Container tools: lazydocker, systemctl-tui
- Security: 1password-cli

**Default Settings:**
- XDG base directories configured
- State version: 25.05

#### Desktop (`home/desktop/`)
Desktop application configuration.

**Modules:**
- `stylix.nix` - Stylix targets for applications
- `programs.nix` - Desktop CLI utilities
- `applications/` - Graphical applications
  - `alacritty.nix` - Terminal emulator
  - `browsers.nix` - Browser configuration (Brave default with extensions)
  - `zen-browser.nix` - Zen browser with workspaces, containers, custom search
  - `zed.nix` - Zed editor with Nix/Rust LSP, vim mode
  - `vicinae.nix` - Application launcher with Catppuccin theme
  - `imv.nix` - Image viewer
  - `mpv.nix` - Media player with modernz UI
  - `mimeapps.nix` - MIME type associations
  - `desktop-entries.nix` - Custom .desktop files

**Applications:**
- Terminal: Alacritty (with hide-on-typing)
- Browsers: Brave (default), Zen, Firefox, Chromium
- Editor: Zed (with nixd LSP, alejandra formatter, vim mode)
- Launcher: Vicinae (Raycast-inspired)
- Media: imv (images), mpv (videos)

**Zen Browser Features:**
- 3 Workspaces: Home, Homelab, Work
- Firefox containers (Work container)
- Pinned sites: GitHub, Reddit, X, YouTube, Amazon, ChatGPT, Proton Mail
- Homelab pins: Density, Datablocks, Paperless, Proxmox, PBS, Gitea, Glances
- Custom search engines (default: Ecosia)

#### Desktop-Tiling (`home/desktop-tiling/`)
Base configuration for tiling window managers.

**Modules:**
- `hyprlock.nix` - Lock screen with screenshot background
- `mako.nix` - Notification daemon (top-right, 5s timeout, 420px width)
- `satty.nix` - Screenshot annotation tool
- `swayosd.nix` - OSD for volume/brightness with Stylix theming
- `programs.nix` - TUI utilities (networkmanagerapplet, udiskie, grim, slurp, wayfreeze)

#### Niri (`home/niri/`)
Niri-specific home configuration.

**Modules:**
- `niri.nix` - Comprehensive Niri window manager configuration
- `waybar.nix` - Status bar configuration
- `hypridle.nix` - Idle management and power saving
- `awww.nix` - Wallpaper daemon
- `programs.nix` - Niri-specific packages

**Niri Configuration:**
- Layout: 12px gaps, focus ring, borders, shadows
- Input: US keyboard, touchpad acceleration, focus-follows-mouse
- Window rules: rounded borders, floating windows (1Password, file managers, media)
- 10 workspaces with mouse wheel switching
- Extensive keybindings (see Niri Keybindings section)

**Hypridle Actions:**
- 3 minutes: Reduce brightness
- 5 minutes: Lock screen
- 7 minutes: Turn off displays
- 10 minutes: Suspend-then-hibernate

#### User-Specific (`home/lorenzo/`)
User-specific home configuration.

**Modules:**
- `git.nix` - Git configuration (Lorenzo Rapetti identity)
- `ssh.nix` - SSH configuration

### Darwin Modules (`modules/darwin/`)

macOS-specific modules (minimal configuration).

### Common Modules (`modules/common/`)

Cross-platform modules shared between NixOS and Darwin.

## Desktop Environments

### Niri Window Manager (Primary)

**Description:** A scrolling window manager for Wayland with dynamic tiling and column-based window organization.

**Components:**
- **Window Manager:** Niri (with xwayland-satellite for X11 compatibility)
- **Display Manager:** SDDM (with astronaut theme, Wayland mode)
- **Status Bar:** Waybar (custom Niri configuration)
- **Notifications:** Mako
- **Lock Screen:** Hyprlock (screenshot background, time/date display)
- **Idle Manager:** Hypridle (brightness, lock, suspend)
- **Wallpaper:** awww daemon
- **Launcher:** Vicinae (Raycast-inspired)
- **Terminal:** Alacritty
- **File Manager:** Nautilus
- **Screenshot:** Custom script (grim + slurp + satty)

**Theme:**
- Color Scheme: Catppuccin Mocha
- Fonts: GeistMono (mono), Noto Sans (sans), Noto Color Emoji
- Cursor: Catppuccin Mocha Dark (24px)

**Key Features:**
- Complete Wayland stack (with optional XWayland)
- Dynamic tiling with column-based layout
- Focus-follows-mouse
- 10 workspaces with mouse wheel navigation
- Hardware video acceleration
- PolicyKit authentication
- Power management integration

### Niri Keybindings

**Mod Key:** Super (Windows key)

#### Window Management
- `Mod+Q` - Close window
- `Mod+Left/Right/Up/Down` or `Mod+H/J/K/L` - Focus window
- `Mod+Shift+Left/Right/Up/Down` or `Mod+Shift+H/J/K/L` - Move window
- `Mod+Comma/Period` - Consume/expel window into/from column
- `Mod+R` - Switch preset column widths
- `Mod+Shift+R` - Reset window height
- `Mod+F` - Maximize window
- `Mod+Shift+F` - Fullscreen window
- `Mod+C` - Center window
- `Mod+Ctrl+Left/Right` - Focus column left/right
- `Mod+Ctrl+H/L` - Focus column left/right
- `Mod+Alt+Left/Right/Up/Down` - Move column
- `Mod+Alt+H/J/K/L` - Move column

#### Workspaces
- `Mod+1-9, 0` - Switch to workspace 1-10
- `Mod+Shift+1-9, 0` - Move window to workspace 1-10
- `Mod+Ctrl+Up/Down` - Focus workspace up/down
- `Mod+Ctrl+K/J` - Focus workspace up/down
- `Mod+Ctrl+Shift+Up/Down` - Move window to workspace up/down
- `Mod+Ctrl+Shift+K/J` - Move window to workspace up/down
- `Mod+Wheel Up/Down` - Switch workspace with mouse wheel

#### Applications
- `Mod+Space` - Vicinae launcher
- `Mod+Shift+Space` - 1Password quick access
- `Mod+T` - Terminal (Alacritty)
- `Mod+E` - File manager (Nautilus)
- `Mod+Y` - Clipboard history
- `Mod+Shift+E` - Emoji selector

#### Screenshots
- `Print` - Screenshot region (annotation with satty)
- `Ctrl+Print` - Screenshot fullscreen (annotation with satty)
- `Alt+Print` - Screenshot region to clipboard
- `Ctrl+Alt+Print` - Screenshot fullscreen to clipboard

#### Media Controls
- `XF86AudioRaiseVolume` - Increase volume
- `XF86AudioLowerVolume` - Decrease volume
- `XF86AudioMute` - Mute audio
- `XF86AudioMicMute` - Mute microphone
- `XF86MonBrightnessUp` - Increase brightness
- `XF86MonBrightnessDown` - Decrease brightness
- `XF86AudioPlay` - Play/pause media
- `XF86AudioNext` - Next track
- `XF86AudioPrev` - Previous track

#### System
- `Mod+Shift+Slash` - Show hotkey overlay
- `Mod+Shift+Q` - Exit Niri (with confirmation)

## Adding a New Host

### Step 1: Create Host Directory

Create a new directory under `hosts/` with your hostname:

```bash
mkdir -p hosts/newhostname
```

### Step 2: Create Configuration File

#### For NixOS:

Create `hosts/newhostname/configuration.nix`:

```nix
{
  pkgs,
  flake,
  ...
}: {
  imports = [
    ./hardware-configuration.nix  # Generated by nixos-generate-config
    flake.nixosModules.common     # Import common NixOS modules
    # Optional: Add desktop environment
    # flake.nixosModules.niri
  ];

  # Boot configuration
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking
  networking.hostName = "newhostname";
  networking.networkmanager.enable = true;

  # Users
  users.users.yourusername = {
    isNormalUser = true;
    description = "Your Name";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  # Optional: Enable additional features
  # hardware.bluetooth.enable = true;
  # services.printing.enable = true;

  system.stateVersion = "25.05";
}
```

#### For macOS (nix-darwin):

Create `hosts/newhostname/darwin-configuration.nix`:

```nix
{
  pkgs,
  flake,
  ...
}: {
  imports = [
    flake.darwinModules.default
  ];

  # Add your Darwin configuration here

  system.stateVersion = 5;
}
```

### Step 3: Generate Hardware Configuration (NixOS only)

```bash
sudo nixos-generate-config --show-hardware-config > hosts/newhostname/hardware-configuration.nix
```

### Step 4: Create User Home Configuration (Optional)

Create `hosts/newhostname/users/yourusername.nix`:

```nix
{flake, ...}: {
  imports = [
    flake.homeModules.common    # Common home configuration
    # Optional: Add desktop applications
    # flake.homeModules.desktop
    # flake.homeModules.niri
    # User-specific modules
    # flake.homeModules.yourusername
  ];

  home = {
    username = "yourusername";
    homeDirectory = "/home/yourusername";  # or "/Users/yourusername" for macOS
    stateVersion = "25.05";
  };
}
```

### Step 5: Build and Deploy

#### NixOS:

```bash
# Build the configuration
sudo nixos-rebuild switch --flake .#newhostname

# Or build without applying
nixos-rebuild build --flake .#newhostname
```

#### macOS (nix-darwin):

```bash
# Build and apply
darwin-rebuild switch --flake .#newhostname
```

### Step 6: Automatic Flake Recognition

Thanks to blueprint, your new host will automatically be available as:
- NixOS: `nixosConfigurations.newhostname`
- macOS: `darwinConfigurations.newhostname`

No need to manually add it to `flake.nix`!

## Configuration Options

### NixOS Module Options

#### Common Module Options

**Docker Configuration:**
```nix
virtualisation.docker = {
  enable = true;           # Enable Docker (default: true)
  enableOnBoot = false;    # Start Docker on boot (default: false)
};
```

**Keyboard Remapping:**
```nix
services.caps2esc.enable = true;  # Map Caps Lock to Esc/Ctrl (default: true)
environment.variables.DEVNODE = "/dev/input/event0";  # Keyboard device path
```

**Nix Settings:**
```nix
nix.settings = {
  experimental-features = [ "nix-command" "flakes" ];
  auto-optimise-store = true;
};

nix.gc = {
  automatic = true;
  dates = "weekly";
  options = "--delete-older-than 7d";
};
```

#### Desktop Module Options

**SwayOSD (Volume/Brightness overlay):**
```nix
services.swayosd.enable = true;  # Enable SwayOSD
```

**Wallpaper Daemon:**
```nix
services.awww.enable = true;  # Enable awww wallpaper daemon
```

**Stylix Theming:**
```nix
stylix = {
  enable = true;
  image = ./path/to/wallpaper.png;
  base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";

  fonts = {
    monospace = {
      package = pkgs.nerd-fonts.geist-mono;
      name = "GeistMono Nerd Font Mono";
    };
    sansSerif = {
      package = pkgs.noto-fonts;
      name = "Noto Sans";
    };
    emoji = {
      package = pkgs.noto-fonts-emoji;
      name = "Noto Color Emoji";
    };
  };

  cursor = {
    package = pkgs.catppuccin-cursors.mochaDark;
    name = "catppuccin-mocha-dark-cursors";
    size = 24;
  };
};
```

**Audio Configuration:**
```nix
services.pipewire = {
  enable = true;
  alsa.enable = true;
  alsa.support32Bit = true;
  pulse.enable = true;
  wireplumber.enable = true;
};
```

**Bluetooth:**
```nix
hardware.bluetooth = {
  enable = true;
  powerOnBoot = true;
  settings.General.Experimental = true;
};
services.blueman.enable = true;
```

**Display Manager:**
```nix
services.displayManager.sddm = {
  enable = true;
  wayland.enable = true;
  theme = "sddm-astronaut-theme";
};
```

#### Power Management Options

**TLP Configuration:**
```nix
services.tlp = {
  enable = true;
  settings = {
    CPU_SCALING_GOVERNOR_ON_AC = "performance";
    CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
    CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
    CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
    CPU_MIN_PERF_ON_AC = 0;
    CPU_MAX_PERF_ON_AC = 100;
    CPU_MIN_PERF_ON_BAT = 0;
    CPU_MAX_PERF_ON_BAT = 50;
  };
};
```

**Thermald:**
```nix
services.thermald.enable = true;  # Intel thermal management
```

**ZRAM Swap:**
```nix
zramSwap = {
  enable = true;
  algorithm = "zstd";  # Compression algorithm
};
```

**SSD Optimization:**
```nix
services.fstrim = {
  enable = true;
  interval = "weekly";  # Run weekly fstrim
};
```

#### Graphics Options

**Intel Graphics:**
```nix
hardware.graphics = {
  enable = true;
  extraPackages = with pkgs; [
    intel-media-driver  # VA-API (iHD)
    vpl-gpu-rt         # oneVPL (QSV)
    intel-compute-runtime  # OpenCL + Level Zero
  ];
};

environment.sessionVariables.LIBVA_DRIVER_NAME = "iHD";

# Intel Arc GPU support
hardware.enableRedistributableFirmware = true;
boot.kernelParams = [ "i915.enable_guc=3" ];
```

**Camera (Intel IPU6):**
```nix
hardware.ipu6 = {
  enable = true;
  platform = "ipu6epmtl";  # Platform-specific
};
```

### Home Manager Module Options

#### Browser Configuration

**Default Browser:**
```nix
xdg.mimeApps.defaultApplications = {
  "text/html" = "brave-browser.desktop";
  "x-scheme-handler/http" = "brave-browser.desktop";
  "x-scheme-handler/https" = "brave-browser.desktop";
};
```

**Zen Browser Workspaces:**
```nix
programs.zen-browser = {
  enable = true;
  policies = {
    ExtensionSettings = { /* ... */ };
    Containers = {
      Work = { /* container config */ };
    };
  };
  profiles.default = {
    workspaces = {
      Home = { /* workspace config */ };
      Homelab = { /* workspace config */ };
      Work = { /* workspace config */ };
    };
  };
};
```

#### Editor Configuration

**Zed Editor:**
```nix
programs.zed-editor = {
  enable = true;
  userSettings = {
    vim_mode = true;
    theme = "Catppuccin Mocha";
    languages = {
      Nix = {
        language_servers = [ "nixd" "!nil" ];
        formatter = { external = { command = "alejandra"; }; };
      };
    };
  };
};
```

**Helix Editor:**
Place configuration in `dotfiles/helix/config.toml` and link via:
```nix
home.file.".config/helix".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix/dotfiles/helix";
```

#### Shell Configuration

**Starship Prompt:**
```nix
programs.starship = {
  enable = true;
  settings = {
    add_newline = true;
    character = {
      success_symbol = "[➜](bold green)";
      error_symbol = "[➜](bold red)";
    };
  };
};
```

**Direnv:**
```nix
programs.direnv = {
  enable = true;
  nix-direnv.enable = true;
  config.whitelist.prefix = [ "~/nix" ];
};
```

#### Niri Window Manager

**Layout Configuration:**
```nix
programs.niri.settings = {
  layout = {
    gaps = 12;
    focus-ring = {
      enable = true;
      width = 2;
    };
    border = {
      enable = true;
      width = 2;
    };
  };

  input = {
    keyboard.xkb = {
      layout = "us";
      options = "compose:ralt";
    };
    focus-follows-mouse = true;
    workspace-auto-back-and-forth = false;
  };

  window-rules = [
    {
      geometry-corner-radius = let r = 8.0; in { top-left = r; top-right = r; bottom-left = r; bottom-right = r; };
      clip-to-geometry = true;
    }
    {
      matches = [{ app-id = "1Password"; }];
      default-column-width = { proportion = 0.5; };
      open-floating = true;
    }
  ];
};
```

**Idle Management:**
```nix
services.hypridle = {
  enable = true;
  settings = {
    general = {
      lock_cmd = "pidof hyprlock || hyprlock";
      before_sleep_cmd = "loginctl lock-session";
      after_sleep_cmd = "niri msg action do-screen-transition";
    };
    listener = [
      { timeout = 180; on-timeout = "brightnessctl -s set 10"; }
      { timeout = 300; on-timeout = "loginctl lock-session"; }
      { timeout = 420; on-timeout = "niri msg action power-off-monitors"; }
      { timeout = 600; on-timeout = "systemctl suspend-then-hibernate"; }
    ];
  };
};
```

#### Notification Configuration

**Mako:**
```nix
services.mako = {
  enable = true;
  anchor = "top-right";
  defaultTimeout = 5000;
  width = 420;
  borderRadius = 8;
};
```

#### Application Launcher

**Vicinae:**
```nix
programs.vicinae = {
  enable = true;
  settings = {
    theme = "catppuccin-mocha";
    extensions = [ "awww-switcher" ];
  };
};
```

## Key Applications

### Development Tools
- **Editors:** Helix (primary), Vim, Neovim, Zed
- **Git:** lazygit (TUI), git CLI
- **LSP:** nixd (Nix), rust-analyzer (Rust)
- **Formatters:** alejandra (Nix), rustfmt (Rust)
- **Linters:** statix (Nix)
- **Containers:** Docker, lazydocker (TUI)

### Browsers
- **Brave:** Default browser with 30+ extensions (uBlock Origin, 1Password, Vimium)
- **Zen Browser:** Firefox-based with workspaces, containers, homelab shortcuts
- **Firefox:** Standard Firefox
- **Chromium:** ungoogled-chromium

### Terminal & Shell
- **Terminal:** Alacritty (GPU-accelerated)
- **Shells:** Bash (primary), Fish, Zsh
- **Prompt:** Starship
- **Multiplexer:** (None configured, but supported)

### System Utilities
- **System Monitor:** btop
- **File Manager:** Nautilus
- **Image Viewer:** imv (Wayland-native)
- **Video Player:** mpv (with modernz UI)
- **Screenshot:** Custom script (grim + slurp + satty)
- **Clipboard:** cliphist (Wayland clipboard history)
- **Password Manager:** 1Password (CLI + GUI)

### Media & Communication
- **Media Player:** mpv (hardware acceleration, Stylix theming)
- **Audio:** PipeWire (with ALSA, PulseAudio compatibility)
- **Bluetooth:** Blueman

### Wayland Tools
- **Launcher:** Vicinae (Raycast-inspired)
- **Notifications:** Mako
- **Lock Screen:** Hyprlock
- **Idle Management:** Hypridle
- **Wallpaper:** awww
- **Status Bar:** Waybar
- **OSD:** SwayOSD (volume/brightness)
- **Clipboard:** wl-clipboard, cliphist

## Development

### Development Shell

Enter the development shell with all necessary tools:

```bash
nix develop
```

This provides:
- Nix tooling (nixd, alejandra, statix)
- Editor support
- Development utilities

### Linting

Run statix to lint Nix code:

```bash
statix check
```

### Formatting

Format Nix code with alejandra:

```bash
alejandra .
```

### Building

Build a specific host without applying:

```bash
# NixOS
nixos-rebuild build --flake .#hostname

# macOS
darwin-rebuild build --flake .#hostname
```

### Testing Changes

Test configuration without committing:

```bash
# NixOS (requires sudo)
sudo nixos-rebuild test --flake .#hostname

# macOS
darwin-rebuild check --flake .#hostname
```

## Useful Commands

### System Management

```bash
# Update flake inputs
nix flake update

# Update specific input
nix flake lock --update-input nixpkgs

# Show flake outputs
nix flake show

# Check flake for errors
nix flake check

# Garbage collect old generations
sudo nix-collect-garbage -d

# Optimize Nix store
nix-store --optimize
```

### Home Manager

```bash
# Apply home configuration changes (if using standalone home-manager)
home-manager switch --flake .#username@hostname

# List home-manager generations
home-manager generations
```

### Niri

```bash
# Reload Niri configuration
niri msg action reload-config

# Show current Niri version
niri --version

# Validate Niri configuration
niri validate
```

## Contributing

When adding new modules or configurations:

1. Follow the existing directory structure
2. Use blueprint's automatic mapping (no manual flake.nix edits needed)
3. Enable modules with `mkEnableOption` for flexibility
4. Use `mkDefault` for overridable defaults
5. Document complex configurations with comments
6. Run `alejandra .` before committing
7. Test with `statix check` for best practices

## Resources

- [NixOS Manual](https://nixos.org/manual/nixos/stable/)
- [Home Manager Manual](https://nix-community.github.io/home-manager/)
- [Nix Package Search](https://search.nixos.org/packages)
- [Nix Options Search](https://search.nixos.org/options)
- [numtide Blueprint](https://numtide.github.io/blueprint/main/)
- [Stylix Documentation](https://stylix.danth.me/)
- [Niri Documentation](https://github.com/YaLTeR/niri)
- [Catppuccin Theme](https://github.com/catppuccin/catppuccin)

## License

This configuration is personal and provided as-is for reference. Feel free to use and adapt for your own systems.
