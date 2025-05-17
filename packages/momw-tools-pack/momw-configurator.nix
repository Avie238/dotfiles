{
  buildGoModule,
  fetchFromGitLab,
}:
buildGoModule rec {
  name = "momw-configurator";
  version = "1.18";
  src = fetchFromGitLab {
    owner = "modding-openmw";
    repo = "momw-configurator";
    rev = version;
    hash = "sha256-Euze4FeALMnwV7mOkBPRvf0SWZxYmXDf+BP+tyJZoZo=";
  };
  vendorHash = "sha256-Pu16/2qZvAkLVb1D3uQt3XrcfBn9lBGY5UVjAGsLKag=";
}
