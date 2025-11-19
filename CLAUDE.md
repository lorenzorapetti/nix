# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a personal NixOS/nix-darwin configuration repository using Nix flakes. It manages system configurations for multiple hosts (Linux and macOS) with a modular architecture powered by the Blueprint flake for automatic structure mapping.

## Essential Commands

### Building and Deploying

```bash
# Rebuild NixOS system (Linux)
sudo nixos-rebuild switch --flake .

# Build without applying (test configuration)
sudo nixos-rebuild build --flake .

# Update flake inputs
nix flake update

# Update specific input
nix flake lock --update-input <input-name>
```

### Development Shell

The repository includes a devshell configuration (`devshell.nix`) that provides:

```bash
# Enter development shell
nix develop

# From within devshell:
switch   # Shortcut for nixos-rebuild switch --flake .
browse   # Browse flake with nix-inspect
```

### Formatting and Linting

```bash
# Format all Nix files with alejandra
nix fmt

# Lint with statix
statix check
```

### Secrets Management

This repository uses sops-nix for secrets:

- Secrets are stored in `secrets/secrets.yaml` (encrypted)
- Age key configuration in `.sops.yaml`
- System age key is auto-generated at `/var/lib/sops-nix/age.agekey`
- To edit secrets: ensure `SOPS_AGE_KEY_FILE` is set and use `sops secrets/secrets.yaml`

## Architecture

### Blueprint-Based Module System

The flake uses the [Blueprint](https://github.com/lorenzorapetti/blueprint) system which automatically maps directory structure to flake outputs:

- `hosts/` → `nixosConfigurations` (host-specific configurations)
- `modules/nixos/` → `nixosModules` (NixOS system modules)
- `modules/home/` → `homeModules` (home-manager modules)
- `modules/common/` → `modules.common` (shared modules)
- `packages/` → `packages` (custom packages)

### Module Organization

**NixOS Modules** (`modules/nixos/`):
- `common/` - Base system configuration (nix settings, kernel, programs, sops, keyboard)
- `desktop/` - Desktop environment base
- `niri/` - Niri window manager configuration
- `lorenzo/` - User-specific system settings

**Home Manager Modules** (`modules/home/`):
- `common/` - Base user configuration (programs, shell, lazygit, direnv, AI tools)
- `desktop/` - Desktop application configurations
- `desktop-tiling/` - Tiling WM utilities (satty, mako, swayosd, hyprlock)
- `niri/` - Niri-specific user configuration (includes waybar, hypridle, awww)
- `lorenzo/` - User-specific home settings

### Host Configuration Pattern

Each host (e.g., `hosts/nixps/`) contains:
- `configuration.nix` - System configuration importing common modules
- `hardware-configuration.nix` - Hardware-specific settings
- `users/<username>.nix` - Per-user home-manager configuration

Host configurations import modules using flake references:
```nix
imports = [
  flake.nixosModules.common
  flake.nixosModules.niri
];
```

User configurations similarly import home modules:
```nix
imports = [
  flake.homeModules.common
  flake.homeModules.niri
  flake.homeModules.lorenzo
];
```

### Current Hosts

- `nixps` - Dell XPS 13 9340 with NixOS, Niri window manager, dual monitors
- `mac14` - macOS system (currently minimal configuration)

### Custom Packages

Located in `packages/`, includes utilities like:
- `mkScript.nix` - Helper for creating shell scripts
- Screenshot/screenrecord utilities
- `ralt2hyper.nix` - Keyboard remapping tool
- `focus-or-open.nix` - Window management utility

### Key Dependencies

- **Stylix** - System-wide color schemes and typography
- **sops-nix** - Secret management with age encryption
- **Niri** - Scrolling window manager (primary desktop environment)
- **Blueprint** - Automatic flake structure mapping
- **nix-darwin** - macOS system management
- **Zen Browser** - Firefox-based browser

### Display Configuration

Monitor setup is configured in host `configuration.nix` using a `monitors` array:
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
];
```

## Development Workflow

1. Make changes to relevant module files in `modules/`
2. Test with `sudo nixos-rebuild build --flake .`
3. Apply with `sudo nixos-rebuild switch --flake .` or `switch` in devshell
4. Format code with `nix fmt` before committing
5. Run `statix check` to catch common Nix issues

## Important Notes

- The flake follows the unstable channel (`nixos-unstable`)
- Hardware-specific configurations use a custom hardware modules fork
- Docker is enabled by default but doesn't auto-start (`enableOnBoot = false`)
- The system uses zram swap with zstd compression
- Intel graphics configuration includes modern iHD VA-API driver setup
