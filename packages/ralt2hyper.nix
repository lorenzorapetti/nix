{
  pkgs,
  pname,
  ...
}: let
  inherit (pkgs) lib stdenv fetchFromGitHub cmake;
in
  stdenv.mkDerivation rec {
    inherit pname;
    version = "1.0.0";

    src = fetchFromGitHub {
      owner = "lorenzorapetti";
      repo = pname;
      rev = version;
      hash = "sha256-mj373rfcKvmnIiHq5rqrM/2UVGN4vaoY7xA97aEilu8=";
    };

    nativeBuildInputs = [
      cmake
    ];

    cmakeFlags = [
      "-DCMAKE_BUILD_TYPE=Release"
      "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
    ];

    meta = with lib; {
      description = "Interception plugin to remap Right Alt (commonly AltGr) to Hyper (i.e. Shift, Control, Alt and Super)";
      homepage = "https://github.com/lorenzorapetti/ralt2hyper";
      license = licenses.mit;
      maintainers = [];
      platforms = platforms.linux;
      mainProgram = "ralt2hyper";
    };
  }
