{
  stdenv,
  fetchFromGitLab,
  go,
  upx,
}:
stdenv.mkDerivation {
  name = "momw-configurator";
  version = "1.18";
  src = fetchFromGitLab {
    owner = "modding-openmw";
    repo = "momw-configurator";
    rev = "0bde7e205e759cc5bbaf15c942d7d74ea594a4cc";
    hash = "sha256-Euze4FeALMnwV7mOkBPRvf0SWZxYmXDf+BP+tyJZoZo=";
  };

  buildInputs = [go upx];

  buildPhase = ''
    ./build.sh linuxarm
  '';
}
