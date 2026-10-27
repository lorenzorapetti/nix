# Global instructions

## devenv projects

If the repo has a `devenv.nix` at its root, its tooling comes from devenv, so run
project commands inside that environment rather than with whatever is on `PATH`:

- `devenv shell -- <cmd> <args>` to run a command in the dev environment
  (e.g. `devenv shell -- cargo test`).
- `devenv tasks list` / `devenv tasks run <task>` for tasks defined in
  `devenv.nix`, and `devenv test` to run its `enterTest`.
- `devenv up` starts the long-running `processes`. Ask before running it, and
  run it in the background if approved.

Read `devenv.nix` (and `devenv.yaml`) to see which languages, packages, scripts
and services it provides before reaching for anything else. A command missing
from the shell but needed by the project belongs in `devenv.nix` — suggest
adding it there instead of using `nix run`.

## Missing commands

This machine runs NixOS, so most tools aren't installed globally. When a command
you need isn't available (e.g. `command not found` for `python3`), don't install
it and don't silently work around it. Instead, ask the user before running it
through nixpkgs ephemerally:

- `nix run nixpkgs#<package> -- <args>` for a single command, or
- `nix shell nixpkgs#<package> --command <cmd> <args>` when the binary name
  differs from the package name or several tools are needed together.

Name the exact package and command in the question, and wait for approval before
running it. If the user declines, fall back to tools that are already available.
