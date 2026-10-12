# CLAUDE.md

Guidance for Claude Code when working in this repository.

## What this repo is

Personal Nix configuration for multiple machines (NixOS + home-manager), built as a
single flake using the **dendritic pattern**, implemented with the **den framework**.

Hosts (each under `modules/hosts/<name>/`):

- `hades` — Framework laptop (Intel Core Ultra Series 3), Hyprland desktop.
- `zagreus` — Beelink SER8 (AMD), Hyprland desktop.
- `nyx` — homelab server: Traefik, Technitium DNS, Glance, Attic cache.
- `nixvm` — test VM, Hyprland desktop.

Read these before making structural decisions — don't guess at conventions:

- Dendritic pattern: https://github.com/mightyiam/dendritic/blob/master/README.md
- Den framework overview: https://den.denful.dev/overview/
- NixOS and Flakes book: https://nixos-and-flakes.thiscute.world/
- NixOS manual: https://nixos.org/manual/nixos/stable/

## Architecture

The flake wires together `flake-parts`, `import-tree`, and `den`:

```nix
{
  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; }
    (inputs.import-tree ./modules);

  inputs = {
    den.url = "github:denful/den";
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";
    home-manager.url = "github:nix-community/home-manager";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # ... follows, theming, hardware, app-specific inputs
  };
}
```

`import-tree ./modules` recursively imports **every** `.nix` file under `modules/`
except ones prefixed with `_`. This means:

- There is no manual registry of module imports anywhere — dropping a file under
  `modules/` is enough to activate it.
- File paths are just organization, not semantics. Any file can be renamed, merged,
  or split without changing behavior.
- Files prefixed `_` are skipped by `import-tree` — use that prefix for plain files
  that are `imports`-ed manually from elsewhere rather than auto-loaded, e.g.
  `modules/hosts/nixvm/_hardware-configuration.nix` or the shared AppImage wrapper
  `modules/_lib/appimage.nix`.

### Dendritic rules to follow

- **Every file is a top-level module.** A file implements one feature and may
  contribute to NixOS and home-manager config for that feature all at once
  — don't split "the nixos half" and "the home-manager half" of one feature into
  unrelated directories unless there's a real reason to.
- **Don't thread values through `specialArgs`.** Share values via `config` (declare
  a custom option under `den`/your own namespace and read it elsewhere) instead of
  passing ad-hoc arguments into module functions.
- **Don't add `enable` options for your own modules.** Importing/activating a file
  (or including an aspect) should be what turns the feature on. `enable` flags are
  for upstream options you don't control, not something to reintroduce yourself.
- **Prefer merging related config under one aspect/module name** over inventing many
  narrowly-named modules — `deferredModule`-style merging is expected.
- **Declare custom options when nixpkgs/home-manager doesn't have the right one** to
  model something (e.g. describing a host's role) instead of working around it.
- Treat all of the above as pragmatic defaults, not absolute law — reasonable
  exceptions are fine when they clearly reduce complexity.

### Den concepts (from https://den.denful.dev/overview/)

Den layers four concerns on top of the dendritic module tree:

- **Entities** — hosts and users declared under `den.hosts.<system>.<hostname>.users.<user>`
  and `den.homes`. This is "what exists."
- **Aspects** (`den.aspects.<name>`) — composable bundles of config spanning multiple
  Nix classes (`nixos`, `homeManager`, `darwin`, ...) in one place. This is "what a
  feature does." Aspects can `includes` other aspects or **batteries** (den's
  built-in aspects, e.g. `den.batteries.hostname`).
- **Policies** — determine how entities relate/route (e.g. host → its users → their
  homes), i.e. "how things connect."
- **Quirks/pipes** — structured data aspects emit and share with each other without
  direct coupling.

Aspect functions take typed context parameters (`{ host, user, ... }`) instead of
booleans/conditionals — Den decides whether an aspect applies based on whether its
declared parameters are available in a given context, not via `lib.mkIf`/`enable`
flags. Because of this, an unused `host`/`user` parameter can still be
load-bearing — don't drop it to satisfy `deadnix`; mark it `# deadnix: skip`.

## Commands

The root `justfile` wraps the nix commands used to build/apply this flake so they
don't need to be retyped. Host defaults to the current machine's hostname
(read from `/etc/hostname`) unless given explicitly.

- `just build [host]` — `nix run .#<host> -- build`, builds the config without
  activating it. This is the safe, side-effect-free command — use it to verify
  changes.
- `just switch [host]` (alias `just s`) — `nix run .#<host> -- switch`, builds
  *and activates* the config on the machine. Bare `just` defaults to this for the
  current host. Treat like other hard-to-reverse/system-affecting actions: only
  run it when the user explicitly asks to switch/apply, not to verify a change.
- `just repl [host]` — `nix run .#<host> -- repl`, opens a nix repl scoped to
  that host's config, useful for inspecting `config`/option values while debugging.
- `just secrets` — `sops modules/secrets/secrets.yaml`, opens the sops-encrypted
  secrets file for editing.
- `just nyx` — builds and switches `nyx` remotely over SSH. Same caution as
  `just switch`.
- `just fmt` — `nix fmt .` (alejandra).
- `just check` — `nix flake check`, which also runs the `statix` and `deadnix`
  checks from `modules/checks.nix`.
- `just update` — `nix flake update`.

## Working in this repo

- New config goes under `modules/` as dendritic files; don't recreate a
  `hosts/<name>/configuration.nix` + `modules/<category>/*.nix` split.
- Flakes only see git-tracked files: `git add` new files before building.
- Prefer extending an existing aspect/module over creating a new one when the
  feature is closely related.
- Validate changes with `just fmt`, `just check` and `just build [host]` (see
  [Commands](#commands)) before considering a change done — this repo has no CI
  to catch eval errors. Prefer `just build` over raw
  `nixos-rebuild`/`home-manager build` invocations so
  verification matches how the user drives this repo. Don't run `just switch`
  (or bare `just`) to verify a change — that activates the config on the
  machine; only run it if the user explicitly asks to switch/apply.
- **Only build/test the current host** — bare `just build`, with no host
  argument — even when a change touches shared modules that other hosts also
  use. Builds are long, so building every affected host isn't worth it. Build a
  different host only when the user explicitly asks, or when the change touches
  only that host and not the current one.
- `statix.toml` disables the `repeated_keys` and `empty_pattern` lints repo-wide;
  don't "fix" those if `statix` flags them elsewhere.
