{pkgs, ...}: {
  # nixpkgs.overlays = [
  #   (self: super: {
  #     bambu-studio = super.appimageTools.wrapType2 rec {
  #       name = "BambuStudio";
  #       pname = "bambu-studio";
  #       version = "02.04.00.70";
  #       ubuntu_version = "24.04_PR-8834";
  #
  #       src = super.fetchurl {
  #         url = "https://github.com/bambulab/BambuStudio/releases/download/v${version}/Bambu_Studio_ubuntu-${ubuntu_version}.AppImage";
  #         sha256 = "sha256-JrwH3MsE3y5GKx4Do3ZlCSAcRuJzEqFYRPb11/3x3r0=";
  #       };
  #
  #       profile = ''
  #         export SSL_CERT_FILE="${super.cacert}/etc/ssl/certs/ca-bundle.crt"
  #         export GIO_MODULE_DIR="${super.glib-networking}/lib/gio/modules/"
  #       '';
  #
  #       extraPkgs = pkgs:
  #         with pkgs; [
  #           cacert
  #           glib
  #           glib-networking
  #           gst_all_1.gst-plugins-bad
  #           gst_all_1.gst-plugins-base
  #           gst_all_1.gst-plugins-good
  #           webkitgtk_4_1
  #         ];
  #     };
  #   })
  # ];

  environment.systemPackages = with pkgs; [
    bambu-studio
  ];
}
