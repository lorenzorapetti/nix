# Nix Configuration

This is my personal Nix configuration for my machines, using [Blueprint](https://github.com/numtide/blueprint).

## Inspiration

First of all, I wanted to shout out all the people from which I learnt how to use Nix.

- [suderman](https://github.com/suderman) for their incredibly well done [nix config](https://github.com/suderman/nixos)
- [zhicaoh](https://github.com/zhichaoh) for the [catppuccin wallpapers](https://github.com/zhichaoh/catppuccin-wallpapers)

## Hosts

- nixps (XPS 13)
- mac14 (Macbook Pro 14 M2 Pro)
- bee (Beelink SER8)

## Main Features

- Theming with Stylix
- Multiple wms planned: Niri, Hyprland, Cosmic
- Secrets management with sops-nix
- Enter the Development Environment automatically with direnv

## Quick Start

### Development Environment

The project uses direnv. If you have it installed, when you enter the project directory, the shell will automatically activate the development environment.

```bash
# Available devshell commands:
switch  # Rebuild and switch configuration
browse  # Inspect flake structure with nix-inspect
```

## Directory Structure

This repository uses [Blueprint](https://github.com/numtide/blueprint), which automatically maps folder structures to flake outputs.

### Root Structure

```
.
├── devshell.nix           # Development shell configuration
│
├── hosts/                 # Host configurations → nixosConfigurations
├── modules/               # Reusable modules → nixosModules/homeModules
├── packages/              # Custom packages → packages.*
├── lib/                   # Helper functions
├── dotfiles/              # Application dotfiles
└── secrets/               # Encrypted secrets (sops-nix)
```

### Hosts (`hosts/`)

**Blueprint mapping**: `hosts/` → `nixosConfigurations.*` / `darwinConfigurations.*`

Each subdirectory represents a system configuration:

```
hosts/
├── nixps/                    # Dell XPS 13 9340 (NixOS)
│   ├── configuration.nix     # System configuration
│   ├── hardware-configuration.nix
│   └── users/
│       └── lorenzo.nix       # User-specific home-manager config
│
└── mac14/                    # macOS system
    └── darwin-configuration.nix
```

In the host configuration file you can import modules defined in `modules/`:

```nix
# hosts/nixps/configuration.nix
imports = [
  flake.nixosModules.common   # Base system configuration
  flake.nixosModules.niri     # Niri window manager
];
```

### Modules (`modules/`)

**Blueprint mapping**: Automatically organized into `nixosModules.*`, `homeModules.*`, `darwinModules.*`

Modules that aren't in `nixos`, `home`, or `darwin` will map to `modules.*`.

Structured by scope and functionality:

```
modules/
├── common/                # Shared modules between NixOS and MacOS
├── nixos/                 # NixOS system modules
│   ├── common/            # Base system configuration (Shared between servers and desktops)
│   ├── desktop/           # Base desktop environment configuration
│   ├── niri/              # Niri window manager system config
│   └── lorenzo/           # User-specific system settings
│
├── darwin/                # MacOS modules
│
└── home/                  # Home Manager modules
    ├── common/            # Base user configuration (Shared between servers and desktops)
    ├── desktop/           # Desktop application configurations
    ├── desktop-tiling/    # Configurations shared between tiling window managers
    ├── niri/              # Niri-specific user configuration
    └── lorenzo/           # User-specific settings
```

### Packages (`packages/`)

**Blueprint mapping**: `packages/` → `packages.*`

Custom derivations and utilities:

```
packages/
├── mkScript.nix        # Helper for creating shell scripts
├── focus-or-open.nix   # Window management utility
├── ralt2hyper.nix      # Keyboard remapping tool
├── screenrecord.nix    # Screen recording script
└── screenshot.nix      # Screenshot utility
```

### Library (`lib/`)

Shared helper functions:

```
lib/
├── default.nix         # Library exports
├── link.nix            # Dotfile linking helper
└── mimetypes.nix       # MIME type utilities
```

## Blueprint Architecture

Blueprint eliminates boilerplate by automatically generating flake outputs from the directory structure:

| Directory | Flake Output |
|-----------|--------------|
| `hosts/` | `nixosConfigurations.*`, `darwinConfigurations.*` |
| `modules/nixos/` | `nixosModules.*` |
| `modules/home/` | `homeModules.*` |
| `modules/darwin/` | `darwinModules.*` |
| `packages/` | `packages.*` |
| `devshell.nix` | `devShells.*` |

### Module Import Pattern

Modules are imported using flake references:

```nix
# In host configuration
imports = [
  flake.nixosModules.common
  flake.nixosModules.desktop
  flake.nixosModules.niri
];

# In user configuration
imports = [
  flake.homeModules.common
  flake.homeModules.desktop
  flake.homeModules.niri
];
```

This provides clean, composable configurations without manual output definitions.

## Key Technologies

- **[Blueprint](https://github.com/numtide/blueprint)**: Convention-over-configuration for Nix flakes
- **[Niri](https://github.com/YaLTeR/niri)**: Scrolling window manager for Wayland
- **[Stylix](https://github.com/danth/stylix)**: System-wide color schemes and typography
- **[sops-nix](https://github.com/Mic92/sops-nix)**: Secret management with age encryption
- **[Home Manager](https://github.com/nix-community/home-manager)**: User environment management
- **[nix-darwin](https://github.com/nix-darwin/nix-darwin)**: macOS system management

## Secrets Management

Secrets are encrypted using [sops-nix](https://github.com/Mic92/sops-nix) with age:

1. System age key auto-generated at `/var/lib/sops-nix/age.agekey`
2. Public key referenced in `.sops.yaml`
3. Secrets stored in `secrets/secrets.yaml` (encrypted)

To edit secrets:
```bash
export SOPS_AGE_KEY_FILE=/var/lib/sops-nix/age.agekey
sops secrets/secrets.yaml
```

## Monitor Configuration

Multi-monitor setups are defined declaratively in host configurations:

```nix
monitors = [
  {
    name = "DP-3";
    width = 3840;
    height = 2160;
    refresh = 120.0;
    position = { x = 0; y = 0; };
    scale = 1.25;
  }
  {
    name = "eDP-1";
    width = 2560;
    height = 1600;
    refresh = 120.0;
    position = { x = 3072; y = 0; };
    scale = 1.3;
  }
];
```

## Updating

```bash
# Update all flake inputs
nix flake update

# Update specific input
nix flake lock --update-input nixpkgs

# Rebuild after update
sudo nixos-rebuild switch --flake .
```

## License

MIT License - See [LICENSE](LICENSE) for details.
