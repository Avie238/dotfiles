{
  fetchFromGitLab,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "delta-plugin";
  version = "0.25.3";

  src = fetchFromGitLab {
    owner = "bmwinger";
    repo = "delta-plugin";
    rev = finalAttrs.version;
    hash = "sha256-zi/qObNrQCPr2bE5a4D8QnJs/szTpnWLmvzqRs0GbZc=";
  };

  cargoHash = "sha256-M6yy35Mvr4tW8sDIjyRECLInMJymOEYIdiAG96aDVRI=";
})
