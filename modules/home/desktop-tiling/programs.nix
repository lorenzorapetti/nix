{
  pkgs,
  perSystem,
  ...
}: {
  home.packages = with pkgs; [
    networkmanagerapplet
    udisks2
    udiskie

    # Screenshot utilities
    grim
    slurp
    wayfreeze
    ffmpeg

    pavucontrol # Mixer control
    libreoffice-qt6-fresh # Office Suite
    papers # Document Viewer
    xournalpp # Annotate PDFs

    perSystem.self.screenshot
    perSystem.self.screenrecord
    perSystem.self.awww-switch
  ];

  programs.satty.enable = true;
}
