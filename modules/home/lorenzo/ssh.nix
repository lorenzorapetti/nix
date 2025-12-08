{
  osConfig,
  config,
  ...
}: {
  programs.ssh = {
    enable = true;

    enableDefaultConfig = false;
    matchBlocks."*" = {
      forwardAgent = false;
      addKeysToAgent = "no";
      compression = false;
      serverAliveInterval = 0;
      serverAliveCountMax = 3;
      hashKnownHosts = false;
      userKnownHostsFile = "~/.ssh/known_hosts";
      controlMaster = "no";
      controlPath = "~/.ssh/master-%r@%n:%p";
      controlPersist = "no";
    };
  };

  services.ssh-agent = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
  };

  home.file = {
    ".ssh/id_ed25519".source = config.lib.file.mkOutOfStoreSymlink osConfig.sops.secrets.lorenzo-ssh-private-key.path;
    ".ssh/id_ed25519.pub".source = config.lib.file.mkOutOfStoreSymlink osConfig.sops.secrets.lorenzo-ssh-public-key.path;
  };
}
