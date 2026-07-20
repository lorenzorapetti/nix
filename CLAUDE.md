# CLAUDE.md

Guidance for Claude Code when working in this repository.

## What this repo is

Personal Nix configuration for multiple machines (NixOS + nix-darwin + home-manager),
built as a single flake. The repo is currently being rewritten from a traditional
`hosts/` + `modules/` layout onto the **dendritic pattern**, implemented with the
**den framework**. Previous hosts (for reference, may not exist yet in the new layout):
`nixps` and `bee` (NixOS), `mac14` (nix-darwin).

The `bee` host will be called `zagreus` in the new layout. The `mac14` host is being
deleted and will not be present in the new layout.

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
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
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
- Files prefixed `_` (e.g. `modules/_nixos/configuration.nix`) are skipped by
  `import-tree` — use that prefix for plain files that are `imports`-ed manually
  from elsewhere rather than auto-loaded (e.g. hardware-configuration.nix-style files).

### Dendritic rules to follow

- **Every file is a top-level module.** A file implements one feature and may
  contribute to NixOS, home-manager, and darwin config for that feature all at once
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
flags.

Building/deploying still works the normal way once hosts are declared:
`nixos-rebuild switch --flake .#<host>`, `darwin-rebuild switch --flake .#<host>`.

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

## Working in this repo

- This repo is **mid-migration**: most of the tree was deleted in the working
  directory as part of moving to the dendritic/den layout. Before assuming a file
  exists, check the actual working tree, not just git history.
- New config should go under `modules/` as dendritic files, not recreate the old
  `hosts/<name>/configuration.nix` + `modules/<category>/*.nix` split.
- Prefer extending an existing aspect/module over creating a new one when the
  feature is closely related.
- Validate changes with `nix flake check` and `just build [host]` (see
  [Commands](#commands)) for an affected host before considering a change done —
  this repo has no CI to catch eval errors. Prefer `just build` over raw
  `nixos-rebuild`/`darwin-rebuild`/`home-manager build` invocations so
  verification matches how the user drives this repo. Don't run `just switch`
  (or bare `just`) to verify a change — that activates the config on the
  machine; only run it if the user explicitly asks to switch/apply.
- `statix.toml` disables the `repeated_keys` and `empty_pattern` lints repo-wide;
  don't "fix" those if `statix` flags them elsewhere.
