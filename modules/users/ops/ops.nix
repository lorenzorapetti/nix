{
  config,
  den,
  ...
}: {
  # Minimal admin user for servers: SSH-key login only, no password.
  # Hosts that have it give wheel passwordless sudo.
  den.aspects.ops = {
    includes = [
      den.batteries.define-user
      den.batteries.primary-user
      (den.batteries.user-shell "fish")
    ];

    homeManager.programs.git.enable = true;

    user.openssh.authorizedKeys.keys = [config.sshKeys.yubikey];
  };
}
