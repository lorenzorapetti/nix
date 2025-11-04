{
  pkgs,
  pname,
  ...
}: let
  inherit (pkgs) lib stdenv fetchFromGitLab cmake;
in
  stdenv.mkDerivation rec {
    inherit pname;
    version = "1.0.0";

    src = fetchFromGitLab {
      owner = "oarmstrong";
      repo = pname;
      rev = version;
      hash = "sha256-b3w8Zs2DrwOiGhPZ7cVDtVUEiMvC/bp5nYQubwp6f5w=";
    };

    nativeBuildInputs = [
      cmake
    ];

    cmakeFlags = [
      "-DCMAKE_BUILD_TYPE=Release"
      "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
    ];

    meta = with lib; {
      description = "Interception plugin to remap Right Alt (commonly AltGr) to Hyper (i.e. Control, Alt and Super)";
      homepage = "https://gitlab.com/oarmstrong/ralt2hyper";
      license = licenses.mit;
      maintainers = [];
      platforms = platforms.linux;
      mainProgram = "ralt2hyper";
    };
  }
