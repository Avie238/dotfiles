{
  buildGoModule,
  fetchFromGitLab,
}:
buildGoModule rec {
  name = "openmw-validator";
  version = "1.14";
  src = fetchFromGitLab {
    owner = "modding-openmw";
    repo = "openmw-validator";
    rev = version;
    hash = "sha256-uA6BZfbOIFg3mLQaTAQ7tx6J0L9x2CeTJwxZWWO/PIg=";
  };

  #FIXME: Skip checks due to file path issues
  checkPhase = '''';

  vendorHash = "sha256-x4n07zJj8M8mraMNMbtGwe/EBzzGVTcK7mrfi9KFips=";
}
