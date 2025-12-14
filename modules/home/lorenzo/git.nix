{...}: {
  programs.git = {
    enable = true;
    ignores = [
      ".DS_Store"
    ];
    settings = {
      core = {
        autocrlf = "input";
      };
      user = {
        name = "Lorenzo Rapetti";
        email = "lorenzo.rapetti.94@gmail.com";
      };
      init.defaultBranch = "main";
      alias = {
        "glog" = "log -E -i --grep";
        "car" = "commit --amend --no-edit";
        "gone" = "!f() { git fetch -p && for branch in $(git for-each-ref --format '%(refname) %(upstream:track)' refs/heads | awk '$2 == \"[gone]\" {sub(\"refs/heads/\", \"\", $1); print $1}'); do git branch -D $branch; done; }; f";
        "unchange" = "checkout --";
        "unstage" = "reset";
        "uncommit" = "reset --soft HEAD^";
        "upstream" = "rev-parse --abbrev-ref --symbolic-full-name @{u}";
        "ureset" = "!git upstream && git reset --hard $(git upstream)";
        "fall" = "fetch --all";
        "aa" = "add --all";
        "ap" = "add --patch";
        "branches" = "for-each-ref --sort=-committerdate --format=\"%(color:blue)%(authordate:relative)\t%(color:red)%(authorname)\t%(color:white)%(color:bold)%(refname:short)\" refs/remotes";
        "b" = "branch";
        "ci" = "commit -v";
        "co" = "checkout";
        "pf" = "push --force-with-lease";
        "s" = "switch";
        "sn" = "switch -c";
        "st" = "status";
        "sl" = "log --oneline --decorate --graph -20";
        "sla" = "log --oneline --decorate --graph --all -20";
        "slap" = "log --oneline --decorate --graph --all";
        "slp" = "log --oneline --decorate --graph";
        "dc" = "diff --word-diff --cached --color-words";
        "df" = "diff --word-diff --color-words";
        "mup" = "!git switch main && git pull && git switch -";
      };
      push = {
        autoSetupRemote = true;
        followTags = true;
      };
      merge.ff = "only";
      fetch = {
        prune = true;
        pruneTags = true;
        all = true;
      };
      color.ui = true;
      column.ui = "auto";
      branch.sort = "committerdate";
      tag.sort = "version:refname";
      diff = {
        algorithm = "histogram";
        colorMoved = "plain";
        mnemonicPrefix = true;
        renames = true;
      };
      help.autocorrect = "prompt";
      commit.verbose = true;
      rerere = {
        enabled = true;
        autoupdate = true;
      };
      rebase = {
        autoSquash = true;
        autoStash = true;
        updateRefs = true;
      };
      pull.rebase = true;
    };
  };
}
