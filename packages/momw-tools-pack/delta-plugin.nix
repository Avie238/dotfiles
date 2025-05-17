{
  fetchFromGitLab,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "delta-plugin";
  version = "0.22.3";

  src = fetchFromGitLab {
    owner = "bmwinger";
    repo = "delta-plugin";
    rev = finalAttrs.version;
    hash = "sha256-8wotQ+ByOo0y1AM1uym7kVt30q6c5JKy6JKCMDKpV/0=";
  };

  cargoHash = "sha256-dOZJsgtJYSr2QjQLBLao0JF7mniir9QRAxl3E5p6P6E=";
})
