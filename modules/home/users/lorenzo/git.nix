{ ... }:
{
  programs.git = {
    enable = true;
    extraConfig.user = {
      name = "Lorenzo Rapetti";
      email = "lorenzo.rapetti.94@gmail.com";
    };
  };
}
