# Global instructions

## Environment

- If an MCP server is unavailable, say so immediately and tell me to run `/mcp` to reconnect. Don't guess.

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

## Running a project's services

Some projects run their services (app servers, databases, queues) with devenv,
some with docker compose, and some ship both. Pick one:

1. If `devenv.nix` defines `processes` or `services` (anything `devenv up`
   would start), use devenv: `devenv up`.
2. Otherwise, if the project has a compose file (`compose.yaml`,
   `docker-compose.yml`, ...), use docker: `docker compose up`. If devenv is
   there too, still use `devenv shell` for the project's commands (see above).

Always ask before starting, stopping or restarting anything, devenv or docker.
Say which one you picked and why. Once approved, run it in the background.

Docker here is rootless podman: `docker` is a wrapper around `podman`, and
`DOCKER_HOST` points at the user's own podman socket. Run `docker` and
`docker compose` directly, without `sudo`. Containers belong to the user, and
the images and volumes are separate from any rootful docker.

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
Check with `command -v <cmd>` first. A `<cmd> 2>/dev/null || <fallback>` chain
also counts as working around a missing command.

## Command output

Command output here is condensed by rtk to save tokens, keeping every signal and
dropping costly noise. Treat it as the complete result: run commands
normally, and batch related commands into one call to avoid extra turns.
Truncated results state their recovery path in their own output. Re-run a
command as `rtk bypass <cmd>` only when its result is unusable: empty when
output was clearly expected, contradicting its exit code, or garbled.

## Editing files

- Never use perl, sed or other regex one-liners to edit source files. Use the Edit tool for every change, including multi-file renames, and re-Read a file after rustfmt has run before editing it again.
