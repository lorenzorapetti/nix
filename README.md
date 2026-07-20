# nix

Personal Nix configuration for multiple machines (NixOS + home-manager), built as a
single flake.

## Repository general structure

The flake wires together [`flake-parts`](https://github.com/hercules-ci/flake-parts),
[`import-tree`](https://github.com/vic/import-tree), and
[`den`](https://den.denful.dev/overview/). It is organized with the **dendritic pattern**
and the **den framework**.

### Dendritic pattern

`import-tree ./modules` recursively imports **every** `.nix` file under `modules/` except
files prefixed with `_`. As a result:

- Each file is a self-contained, top-level module implementing one feature (it can
  contribute NixOS, home-manager, and darwin config at once).
- There is no manual registry of imports — dropping a file under `modules/` activates it.
- File paths are just organization, not semantics; files can be renamed, merged, or split
  without changing behavior.
- `_`-prefixed files (e.g. `_hardware-configuration.nix`) are skipped by `import-tree` and
  are meant to be `imports`-ed manually from elsewhere.

### Den framework & the aspects pattern

Den layers a few concerns on top of the dendritic module tree. The central one is the
**aspects pattern**:

- **Aspects** (`den.aspects.<name>`) are composable bundles of config that span multiple
  Nix classes (`nixos`, `homeManager`, `darwin`, ...) in one place — "what a feature
  does."
- An aspect can pull in other aspects (or den's built-in **batteries**) via `includes`,
  so features compose transitively.
- **Entities** — hosts and users — are declared under
  `den.hosts.<system>.<hostname>.users.<user>` and opt into aspects.
- Aspect functions take typed context parameters (`{ host, user, ... }`) and Den decides
  whether an aspect applies based on the available context, instead of `enable` flags or
  `lib.mkIf` conditionals.

Den also **automatically creates an aspect for every host and every user**. For example,
declaring `den.hosts.x86_64-linux.zagreus.users.lorenzo` yields a `den.aspects.zagreus`
aspect and a `den.aspects.lorenzo` aspect that hold that entity's own config (see
`modules/hosts/zagreus/default.nix`).

Learn more:

- Dendritic pattern — <https://github.com/mightyiam/dendritic/blob/master/README.md>
- Den framework — <https://den.denful.dev/overview/>

## Hosts

The **Aspects** column lists the aspects each host includes directly in its
`modules/hosts/<name>/default.nix`. On top of these, the `den.default` aspect applies to
every host, and the user aspect `lorenzo` (which itself pulls in `shell`, `ai`, and
`sops`) applies to its user. Included aspects also expand transitively (e.g. `base` and
`desktop.hyprland` pull in many more).

| Host | Machine | System | Aspects |
|------|---------|--------|---------|
| `zagreus` | Beelink SER8 | `x86_64-linux` | `base`, `hardware.cpu-amd`, `hardware.igpu-amd`, `hardware.firmware`, `theming.catppuccin`, `desktop.bluetooth`, `desktop.hyprland`, `development`, `docker` |
| `nixvm` | Virtual machine | `x86_64-linux` | `base`, `theming.catppuccin`, `desktop.hyprland`, `development` |

Build/deploy a host with:

```sh
nixos-rebuild switch --flake .#<host>
```

## Add a new host

See [`docs/new-host.md`](docs/new-host.md).

## Acknowledgments

This configuration's structure is built on top of:

- [Dendritic pattern](https://github.com/mightyiam/dendritic/blob/master/README.md)
- [Den framework](https://den.denful.dev/overview/)
