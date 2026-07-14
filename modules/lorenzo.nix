{den, ...}: {
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
    ];

    # user can provide NixOS configurations
    # to any host it is included on
    # provides.to-hosts.nixos = {pkgs, ...}: {};

    meta = {
      email = "me@lorenzorapetti.com";
      fullName = "Lorenzo Rapetti";
      username = "lorenzo";
    };
  };
}
