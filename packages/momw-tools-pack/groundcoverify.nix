{
  lib,
  stdenv,
  fetchFromGitLab,
  python3,
  makeWrapper,
  delta-plugin,
}:
stdenv.mkDerivation rec {
  pname = "groundcoverify";
  version = "0.2.4";

  src = fetchFromGitLab {
    owner = "bmwinger";
    repo = "groundcoverify";
    rev = version;
    hash = "sha256-mu/ZHoB+mnsuzk8TOJHbZSfowMPfg2c550OiSuWfb4Q=";
  };

  patches = [./patch.patch];
  nativeBuildInputs = [makeWrapper];

  installPhase = ''
    mkdir -p $out/bin

    install -m +x $src/${pname}.py $out/bin/${pname}

    wrapProgram $out/bin/${pname} \
      --prefix PATH : ${
      lib.makeBinPath [
        delta-plugin
        python3
      ]
    }
  '';
}
