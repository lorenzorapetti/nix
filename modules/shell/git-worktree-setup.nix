{
  perSystem = {pkgs, ...}: {
    packages.git-worktree-setup = pkgs.writeShellApplication {
      name = "git-worktree-setup";
      runtimeInputs = with pkgs; [coreutils git gnused];
      # The hook must always exit 0, and every failure below is handled
      # explicitly, so leave errexit off.
      bashOptions = ["nounset" "pipefail"];
      text = ''
        # Prepare a new git worktree from the primary worktree. Paths matched by
        # the primary's .worktreelink are shared: symlinked back to the primary,
        # so every worktree sees one copy. Paths matched by .worktreeinclude are
        # seeded: reflink-copied, and diverging from then on. Both files use
        # gitignore syntax and only match untracked, ignored paths; anchor
        # entries with a leading / to match at the repo root only.
        #
        # Runs as a global post-checkout config hook (hook.worktree-setup in the
        # git config): git calls it as `<null-ref> <new-HEAD> 1` on `git worktree
        # add`. Run it with no arguments inside a worktree to repair a partial
        # setup. Existing paths are never overwritten.
        #
        # Always exits 0: a failing hook makes `git worktree add`, and the tool
        # behind it (Herdr, lazygit, Claude Code), report an error.

        # Hook mode only acts on a null previous HEAD, i.e. a fresh checkout.
        if [[ $# -gt 0 && ! ''${1:-} =~ ^0+$ ]]; then
          exit 0
        fi

        # Clones and the primary share their git dir; only linked worktrees
        # have a separate one.
        git_dir=$(git rev-parse --path-format=absolute --git-dir 2>/dev/null) ||
          exit 0
        common_dir=$(git rev-parse --path-format=absolute --git-common-dir) ||
          exit 0
        [[ $git_dir != "$common_dir" ]] || exit 0

        worktree=$(git rev-parse --show-toplevel) || exit 0

        # A GIT_DIR, GIT_WORK_TREE, ... inherited from the caller would override
        # the `git -C "$primary"` below and make it list the new worktree.
        # shellcheck disable=SC2046
        unset $(git rev-parse --local-env-vars)

        # The first entry is the primary; a bare one has nothing to share.
        list=$(git worktree list --porcelain) || exit 0
        primary=$(sed -n '1s/^worktree //p' <<<"$list")
        [[ $(sed -n '2p' <<<"$list") != bare ]] || exit 0
        [[ -d $primary && $primary != "$worktree" ]] || exit 0

        log() { echo "git-worktree-setup: $*" >&2; }

        # Untracked paths in the primary matching the list's patterns; whole
        # directories collapse into a single entry.
        matches() {
          [[ -f $primary/$1 ]] || return 0
          git -C "$primary" ls-files -z --others --ignored --directory \
            --exclude-from="$1"
        }

        # mode is "shared" (symlink to the primary) or "seeded" (copy).
        place() {
          if [[ $1 == shared ]]; then
            ln -s "$2" "$3"
          else
            cp -a --reflink=auto "$2" "$3"
          fi
        }

        apply() {
          local list=$1 mode=$2 path target
          while IFS= read -r -d "" path; do
            path=''${path%/}
            target=$worktree/$path
            [[ -e $target || -L $target ]] && continue
            if ! mkdir -p "$(dirname "$target")"; then
              log "cannot create parent of $path"
              continue
            fi
            if place "$mode" "$primary/$path" "$target"; then
              log "$mode $path"
            else
              log "failed to set up $path"
            fi
          done < <(matches "$list")
        }

        apply .worktreelink shared
        apply .worktreeinclude seeded
        exit 0
      '';
    };
  };

  den.aspects.shell = {
    homeManager = {
      lib,
      self',
      ...
    }: {
      home.packages = [self'.packages.git-worktree-setup];

      programs.git.settings.hook.worktree-setup = {
        event = "post-checkout";
        command = lib.getExe self'.packages.git-worktree-setup;
      };
    };
  };
}
