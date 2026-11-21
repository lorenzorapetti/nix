{
  den.aspects.podman = {
    nixos = {pkgs, ...}: {
      virtualisation.podman = {
        enable = true;
        # `docker` is a wrapper around podman, so docker CLI habits and scripts keep working.
        dockerCompat = true;
        # Containers on the same network resolve each other by name, as with docker.
        defaultNetwork.settings.dns_enabled = true;
      };

      # Provider for `podman compose` / `docker compose`.
      environment.systemPackages = [pkgs.docker-compose];
    };

    homeManager = {
      # The podman module already starts each user's rootless API socket; point
      # docker-API clients like lazydocker and docker-compose at it.
      home.sessionVariables.DOCKER_HOST = "unix://\${XDG_RUNTIME_DIR}/podman/podman.sock";

      programs.lazydocker.enable = true;
    };
  };
}
