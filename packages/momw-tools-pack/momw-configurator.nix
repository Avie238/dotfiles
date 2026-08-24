{
  buildGoModule,
  fetchFromGitLab,
}:
buildGoModule rec {
  name = "momw-configurator";
  version = "1.25";
  src = fetchFromGitLab {
    owner = "modding-openmw";
    repo = "momw-configurator";
    rev = version;
    hash = "sha256-whh7Da5Z40GfLYlxfdh0ZZOWnAgwPy0mvevUWshve64=";
  };
  vendorHash = "sha256-Pu16/2qZvAkLVb1D3uQt3XrcfBn9lBGY5UVjAGsLKag=";
}
