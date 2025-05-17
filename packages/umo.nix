{
  stdenv,
  widevine-cdm,
  fetchFromGitLab,
  python3,
  pipx,
}:
stdenv.mkDerivation {
  name = "umo";
  version = widevine-cdm.version;
  src = fetchFromGitLab {
    owner = "modding-openmw";
    repo = "umo";
    rev = "b0827b9932f55db78a1c1bc39a9d56f99a8f77a3";
    hash = "sha256-lEkYSK07sAC9miXMJkaxXoBfW5+X/ztp5pT7o4Wo2lQ=";
  };

  buildInputs = [python3 pipx];

  buildPhase = ''
    make install DEST_BINDIR=$out/bin
  '';
}
