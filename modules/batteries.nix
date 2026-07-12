{lib, ...}: {
  den.batteries.extra-groups = groups: {
    user,
    host,
    ...
  }: {
    name = "extra-groups(${user.userName}@${host.name})";
    nixos = {config, ...}:
      lib.optionalAttrs (lib.elem "wheel" config.users.users.${user.userName}.extraGroups) {
        users.users.${user.userName}.extraGroups = groups;
      };
  };
}
