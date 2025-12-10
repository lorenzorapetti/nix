{...}: {
  home.shellAliases = {
    n = "cd ~/nix && nvim";
    la = "ls -la";
    g = "git";
    gs = "git status";
    ga = "git add";
    gaa = "git add --all";
    gc = "git commit";
    gcm = "git commit -m";
    gca = "git commit --amend";
    gcam = "git commit --amend -m";
    gco = "git checkout";
    gcb = "git checkout -b";
    gcl = "git clone";
    gp = "git push";
    gpl = "git pull";
    gl = "git log --oneline --graph --decorate --all";
    gld = "git log --pretty=format:'%C(yellow)%h%C(reset) - %an [%C(green)%ar%C(reset)] %s'";
  };
}
