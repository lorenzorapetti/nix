{den, ...}: let
  sshKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ0iBia+xeEjiuMt8QPQ4g03TVOt66zG69R6oFal6o3M";
in {
  den.aspects.lorenzo = {
    includes = [
      # Creates OS-level user accounts (users.users.<name>) with isNormalUser and home directory.
      # Also sets home.username and home.homeDirectory for Home Manager. Works on NixOS, Darwin, and standalone Home Manager.
      den.batteries.define-user

      # Marks a user as the primary (admin-level) user. On NixOS, adds wheel and networkmanager groups.
      # On Darwin, sets system.primaryUser. On WSL, sets defaultUser.
      den.batteries.primary-user

      # Projects user-relevant classes (like homeManager) from the host’s aspect tree onto users who opt in.
      # Any homeManager key defined in the host aspect is forwarded to the user’s home-manager evaluation.
      den.batteries.host-aspects

      # Sets the user’s login shell at both OS and Home Manager levels.
      # Enables programs.<shell>.enable and sets users.users.<name>.shell.
      (den.batteries.user-shell "fish")

      den.aspects.shell
      den.aspects.ai
    ];

    # user can provide NixOS configurations
    # to any host it is included on
    # provides.to-hosts.nixos = {pkgs, ...}: {};

    meta = {
      email = "me@lorenzorapetti.com";
      fullName = "Lorenzo Rapetti";
      username = "lorenzo";
    };

    homeManager = {
      programs.git = {
        enable = true;

        ignores = [
          ".lazy.lua"
          ".DS_Store"
          ".mise.local.toml"
          "**/.claude/settings.local.json"
        ];

        signing = {
          key = sshKey;
          format = "ssh";
          signByDefault = true;
        };

        settings = {
          core = {
            autocrlf = "input";
          };

          user = {
            name = "Lorenzo Rapetti";
            email = "lorenzo.rapetti.94@gmail.com";
          };

          init.defaultBranch = "main";

          gpg.ssh.allowedSignersFile = "~/.config/git/allowed_signers";

          commit = {
            verbose = true;
            gpgsign = true;
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

          alias = {
            glog = "log -E -i --grep";
            car = "commit --amend --no-edit";
            gone = ''!f() { git fetch -p && for branch in $(git for-each-ref --format '%(refname) %(upstream:track)' refs/heads | awk '$2 == "[gone]" {sub("refs/heads/", "", $1); print $1}'); do git branch -D $branch; done; }; f'';
            unchange = "checkout --";
            unstage = "reset";
            uncommit = "reset --soft HEAD^";
            upstream = "rev-parse --abbrev-ref --symbolic-full-name @{u}";
            ureset = "!git upstream && git reset --hard $(git upstream)";
            fall = "fetch --all";
            aa = "add --all";
            ap = "add --patch";
            branches = ''for-each-ref --sort=-committerdate --format="%(color:blue)%(authordate:relative)\t%(color:red)%(authorname)\t%(color:white)%(color:bold)%(refname:short)" refs/remotes'';
            b = "branch";
            ci = "commit -v";
            co = "checkout";
            pf = "push --force-with-lease";
            s = "switch";
            sn = "switch -c";
            st = "status";
            sl = "log --oneline --decorate --graph -20";
            sla = "log --oneline --decorate --graph --all -20";
            slap = "log --oneline --decorate --graph --all";
            slp = "log --oneline --decorate --graph";
            dc = "diff --word-diff --cached --color-words";
            df = "diff --word-diff --color-words";
            mup = "!git switch main && git pull && git switch -";
          };
        };
      };
    };

    user = {
      openssh.authorizedKeys.keys = [
        sshKey
      ];
    };
  };
}
