{inputs, ...}: {
  perSystem = {
    pkgs,
    self',
    ...
  }: {
    packages.herdr-worktree-current = pkgs.writeShellApplication {
      name = "herdr-worktree-current";
      runtimeInputs = with pkgs; [git jq];
      # A failing `herdr workspace list` or a $PWD outside any repo are normal
      # here and must fall through to the git fallback, so leave errexit off.
      bashOptions = ["nounset" "pipefail"];
      text = ''
        # Print the checkout you are looking at, so the lazygit popup knows what "here"
        # means.
        #
        # The focused workspace wins over $PWD, because this runs from a herdr popup and
        # a popup's working directory is herdr's business rather than the workspace's: it
        # can sit on the repo root while you are looking at one of its worktrees. But it
        # only wins within the same repository, so running it straight from a shell can
        # never reach across into whatever repo happens to be on screen.

        herdr=''${HERDR_BIN_PATH:-herdr}

        repo_of() {
          git -C "$1" rev-parse --path-format=absolute --git-common-dir 2>/dev/null
        }

        focused=$("$herdr" workspace list 2>/dev/null \
          | jq -r 'first(.result.workspaces[]
              | select(.focused == true and .worktree != null)
              | .worktree.checkout_path) // empty')

        here=$(repo_of "$PWD")

        if [[ -n $focused ]] && { [[ -z $here ]] || [[ $(repo_of "$focused") == "$here" ]]; }; then
          printf '%s\n' "$focused"
          exit 0
        fi

        git rev-parse --show-toplevel 2>/dev/null
      '';
    };

    packages.herdr-linear = let
      # Lays out `linear issue query --json` like `linear issue list` does: same
      # columns, glyphs and colors. Each line is `<identifier>\t<row>`, and the
      # first one is the header.
      filter = pkgs.writeText "herdr-linear.jq" ''
        def esc: "\u001b[" + . + "m";
        def paint($code): if $code == null or . == "" then . else ($code | esc) + . + ("0" | esc) end;
        def pad($width): . + (" " * ($width - length));

        def rgb:
          if test("^#[0-9a-fA-F]{6}$") then
            .[1:] | ascii_downcase | explode | map(if . >= 97 then . - 87 else . - 48 end)
            | "38;2;\(.[0] * 16 + .[1]);\(.[2] * 16 + .[3]);\(.[4] * 16 + .[5])"
          else null end;

        def priority:
          {"0": "---", "1": "⚠⚠⚠", "2": "▄▆█", "3": "▄▆ ", "4": "▄  "}[tostring] // tostring;

        # The issue's cycle relative to the team's active one, and its color.
        def cycle:
          .team.activeCycle.number as $anchor
          | .cycle as $c
          | if $c == null then ["-", "90"]
            elif $c.isActive then ["now", "32"]
            elif $c.isNext then ["+1", null]
            elif $c.isPrevious then ["-1", "90"]
            elif $anchor != null then
              ($c.number - $anchor) as $offset
              | if $offset == 0 then ["now", "32"]
                elif $offset > 0 then ["+\($offset)", null]
                else ["\($offset)", "90"] end
            else ["#\($c.number)", (if $c.isPast then "90" else null end)] end;

        # Whether an unfinished issue blocks this one.
        def blocked:
          any(.inverseRelations[]?;
            .type == "blocks" and (.issue.state.type | IN("completed", "canceled") | not));

        def ago:
          (sub("\\.[0-9]+Z$"; "Z") | fromdateiso8601) as $then
          | (now - $then) as $elapsed
          | def count($value; $unit): "\($value) \($unit)\(if $value == 1 then "" else "s" end) ago";
            if $elapsed < 60 then "just now"
            elif $elapsed < 3600 then count($elapsed / 60 | floor; "minute")
            elif $elapsed < 86400 then count($elapsed / 3600 | floor; "hour")
            elif $elapsed < 604800 then count($elapsed / 86400 | floor; "day")
            else $then | strflocaltime("%Y-%m-%d") end;

        # A cell is a list of differently colored segments.
        def seg($text; $code): {text: $text, code: $code};

        def cells:
          [ [seg(.priority | priority; null)],
            [seg(.identifier; null)],
            [seg(.title | gsub("[\t\n]"; " "); null)],
            (reduce (.labels[] | seg(.name; .color | rgb)) as $label ([];
              if length > 0 then . + [seg(", "; null), $label] else [$label] end)),
            [if blocked then seg("⊘"; "33") else seg(""; null) end],
            [seg(.estimate // "-" | tostring; null)],
            [cycle | seg(.[0]; .[1])],
            [seg(.state.name; .state.color | rgb)],
            [seg(.updatedAt | ago; "90")] ];

        def width: map(.text | length) | add // 0;

        ["◌", "ID", "TITLE", "LABELS", "B", "E", "CYC", "STATE", "UPDATED"] as $head
        | map({id: .identifier, cells: cells}) as $rows
        | [range($head | length) as $i
            | [($head[$i] | length), ($rows[].cells[$i] | width)] | max] as $widths
        | if $rows == [] then empty else
            "\t" + ([range($head | length) as $i | $head[$i] | pad($widths[$i]) | paint("1;4")] | join("  ")),
            ($rows[]
              | .id + "\t" + ([range(.cells | length) as $i
                  | .cells[$i]
                  | (map(.code as $code | .text | paint($code)) | join("")) + (" " * ($widths[$i] - width))]
                | join("  ")))
          end
      '';
    in
      pkgs.writeShellApplication {
        name = "herdr-linear";
        runtimeInputs = [self'.packages.linear-cli pkgs.jq pkgs.fzf pkgs.git];
        text = ''
          # Pick one of your issues in the active cycle, then one of the top-level herdr
          # workspaces, and open a worktree there on the branch Linear suggests for it.

          herdr=''${HERDR_BIN_PATH:-herdr}

          # This runs in a popup, which closes as soon as it exits: keep any error on
          # screen until it has been read.
          trap '[[ -t 0 ]] && read -rsn1 -p "Press any key to close"' ERR

          # Both pickers take `<id>\t<row>` lines, show the row and print the id.
          pick() {
            fzf --ansi --delimiter='\t' --with-nth=2.. --accept-nth=1 \
              --layout=reverse --tiebreak=index "$@"
          }

          issues=$(linear issue query --team "''${LINEAR_TEAM_ID:?LINEAR_TEAM_ID is not set}" \
            --cycle active --assignee "@me" --json --no-input)
          rows=$(jq -r -f ${filter} <<<"$issues")

          if [[ -z $rows ]]; then
            echo "No issues found." >&2
            false
          fi

          # Cancelling either picker is not an error.
          issue=$(pick --header-lines=1 <<<"$rows") || exit 0

          branch=$(linear issue view "$issue" --json --no-input | jq -er .branchName)

          # Workspaces opened on a linked worktree are ones like the one this creates,
          # not the repositories to create it in.
          workspaces=$("$herdr" workspace list | jq -r '
            [.result.workspaces[] | select(.worktree.is_linked_worktree != true)]
            | (map(.label | length) | max) as $width
            | .[]
            | .workspace_id + "\t"
              + "\u001b[90m\(.number)\u001b[0m  "
              + .label + (" " * ($width - (.label | length)))
              + "  \u001b[90m\(.tokens.topic // "")\u001b[0m"')

          workspace=$(pick --header="$issue  $branch" <<<"$workspaces") || exit 0

          # Starting work on it: move it out of "not started".
          state=$(jq -r --arg issue "$issue" '.[] | select(.identifier == $issue) | .state.type' <<<"$issues")
          if [[ $state == unstarted ]]; then
            linear issue update "$issue" --state "In Progress" --no-input >/dev/null
          fi

          worktrees=$("$herdr" worktree list --workspace "$workspace" --trust-repository)
          existing=$(jq -c --arg branch "$branch" \
            'first(.result.worktrees[] | select(.branch == $branch)) // empty' <<<"$worktrees")

          # Already open in a workspace: just go there.
          open_workspace=$(jq -r '.open_workspace_id // empty' <<<"$existing")
          if [[ -n $open_workspace ]]; then
            "$herdr" workspace focus "$open_workspace" >/dev/null
            exit 0
          fi

          # Checked out but not open (e.g. its workspace was closed): reopen it, since
          # creating it again would fail on the existing branch and checkout.
          if [[ -n $existing ]]; then
            action=(open)
          else
            # A new branch starts from an up-to-date default branch. Pull it where it is
            # checked out, otherwise fast-forward it without touching the checkout.
            source=$(jq -er .result.source.source_checkout_path <<<"$worktrees")
            default=$(git -C "$source" symbolic-ref --short refs/remotes/origin/HEAD)
            default=''${default#origin/}
            if [[ $(git -C "$source" branch --show-current) == "$default" ]]; then
              git -C "$source" pull --ff-only --quiet
            else
              git -C "$source" fetch --quiet origin "$default:$default"
            fi
            action=(create --base "$default")
          fi
          opened=$("$herdr" worktree "''${action[@]}" --workspace "$workspace" --branch "$branch" \
            --focus --trust-repository)

          # Trust the checkout's devenv from its own shell, so the shell picks the
          # environment up straight away.
          checkout=$(jq -er .result.worktree.path <<<"$opened")
          if [[ -e $checkout/devenv.nix ]]; then
            pane=$(jq -er .result.root_pane.pane_id <<<"$opened")
            "$herdr" pane run "$pane" "devenv allow" >/dev/null
          fi
        '';
      };
  };

  den.aspects.shell = {
    homeManager = {
      config,
      herdrPlugins,
      self',
      ...
    }: {
      imports = [inputs.herdr-nix.homeModules.default];

      home.packages = [
        self'.packages.herdr-worktree-current
        self'.packages.herdr-linear
      ];

      programs.herdr = {
        enable = true;
        plugins = with herdrPlugins; [
          herdr-bar
          herdr-auto-title
          herdr-last-workspace
          herdr-worktree-from-linear
        ];
        pluginSettings = {
          herdr-bar = {
            auto_titles = false;
          };
          "tdi.worktree-from-linear" = {
            placement = "popup";
          };
        };
      };

      xdg.configFile."herdr/config.toml".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix/dotfiles/herdr/config.toml";
    };
  };
}
