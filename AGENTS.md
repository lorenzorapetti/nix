# AGENTS.md - Agent Guidelines for NixOS/nix-darwin Configuration

This repository hosts a personal NixOS and nix-darwin configuration using **Nix Flakes** and the **Blueprint** architecture. It manages system configurations for multiple hosts (Linux/macOS) with a modular structure.

## 1. Build, Lint, and Verify Commands

There is no standard "unit test" suite. Verification relies on building configurations, linting, and flake checks.

### Core Lifecycle Commands
- **Build & Switch (Apply)**: `sudo nixos-rebuild switch --flake .`
  - Applies the configuration to the current machine.
- **Build Only (Dry Run)**: `sudo nixos-rebuild build --flake .`
  - *Crucial step*: Run this to verify that your changes compile before asking the user to switch.
- **Format Code**: `nix fmt`
  - Uses `alejandra`. **Must** be run before every commit.
- **Lint Code**: `statix check`
  - Checks for common Nix antipatterns. Fix these before finishing a task.
- **Update Lockfile**: `nix flake update`

### Development Environment
- **Enter Shell**: `nix develop`
  - Provides a shell with all necessary CLI tools (`nixos-rebuild`, `sops`, `alejandra`, `statix`, `nix-inspect`).
- **Shortcuts (inside devshell)**:
  - `switch`: Alias for `sudo nixos-rebuild switch --flake .`
  - `browse`: Inspect the flake outputs using `nix-inspect`.

### Secrets Management
- **Tool**: `sops-nix`
- **File**: `secrets/secrets.yaml`
- **Editing**: `sops secrets/secrets.yaml` (Requires `SOPS_AGE_KEY_FILE`).
- **Safety**: **NEVER** commit decrypted secrets. Reference them in code via `config.sops.secrets.<name>.path`.

## 2. Architecture & Directory Structure

This project uses [Blueprint](https://github.com/lorenzorapetti/blueprint) to automatically map directories to flake outputs.

| Directory | Flake Output | Description |
|-----------|--------------|-------------|
| `hosts/<hostname>/` | `nixosConfigurations.<hostname>` | Host entry points (system config). |
| `modules/nixos/` | `nixosModules` | NixOS system-level modules. |
| `modules/home/` | `homeModules` | Home Manager user-level modules. |
| `modules/common/` | `modules.common` | Shared/generic modules. |
| `packages/` | `packages` | Custom packages (scripts, tools). |

### Host Configuration Pattern
Each host in `hosts/` (e.g., `nixps`, `mac14`) typically contains:
- `configuration.nix`: Main system entry point. Imports `flake.nixosModules.*`.
- `hardware-configuration.nix`: Hardware specific settings.
- `users/<username>.nix`: User Home Manager config. Imports `flake.homeModules.*`.

**Example Import Style:**
```nix
imports = [
  flake.nixosModules.common
  flake.nixosModules.niri
  # ...
];
```

## 3. Code Style & Conventions

### Formatting & Syntax
- **Indentation**: 2 spaces.
- **Lists**: Multi-line lists end with semicolons.
- **Strings**: Prefer multi-line strings (`'' ... ''`) for config files or scripts.
- **Tooling**: Strict adherence to `alejandra` (run `nix fmt`).

### Naming Conventions
- **Files**: `camelCase.nix` (e.g., `obsidian.nix`) or `kebab-case.nix` (match existing folder context).
- **Variables**: `camelCase`.
- **Options**: Use hierarchy (e.g., `programs.myTool.enable`).

### Module Best Practices
1.  **Use `lib.mkOption`**: When defining new modules, strictly define options with types (e.g., `lib.types.bool`).
2.  **Top-level Arguments**:
    - Use `{ pkgs, lib, config, ... }:` standard arguments.
    - **Avoid** importing `nixpkgs` directly; use the `pkgs` argument passed to the module.
3.  **Inputs**: Access flake inputs via `inputs.<name>` if passed, or `flake.inputs.<name>`.
4.  **Relative Paths**: Avoid `../../`. Use the module system or `flake.*` references provided by Blueprint.

### Dependencies & Ecosystem
- **Stylix**: Used for system-wide theming (colors, fonts).
- **Niri**: The primary Wayland window manager.
- **Sops-nix**: Secrets.
- **Home Manager**: Manages user dotfiles.

## 4. Operational Workflow for Agents

When implementing changes, follow this strictly:

1.  **Analyze**:
    - Locate the relevant module in `modules/nixos` (system) or `modules/home` (user).
    - Check `hosts/` to see which hosts utilize that module.
2.  **Edit**:
    - Make atomic changes.
    - If adding a new package, prefer adding it to an existing relevant module (e.g., add `git` to `modules/home/common/git.nix`) rather than `configuration.nix` directly.
3.  **Format & Lint**:
    - Run `nix fmt` immediately.
    - Run `statix check`.
4.  **Build (Verify)**:
    - Run `sudo nixos-rebuild build --flake .` to compile the derivation.
    - If you lack sudo, ask the user to run the build, or run `nix build .#nixosConfigurations.<host>.config.system.build.toplevel` if possible.
5.  **Refine**:
    - If the build fails, analyze the Nix error trace.
    - Check for missing semicolons, undefined variables, or type mismatches.

## 5. Specific Configuration Notes

- **Monitors**: Configured in `configuration.nix` via a `monitors` list of attribute sets (name, width, height, refresh, position, scale).
- **Custom Packages**: Found in `packages/`. Includes helpers like `mkScript.nix`.
- **ZRAM**: Enabled by default with zstd.
- **Docker**: Enabled but `enableOnBoot = false`.

**Error Handling Strategy**:
- Nix errors are often obscure. Read the stack trace bottom-up.
- Common issues: Infinite recursion (circular imports), missing `pkgs` in arguments, syntax errors (missing `;`).
