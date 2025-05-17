{
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "s3lightfixes";
  version = "v0.3.3";

  src = fetchFromGitHub {
    owner = "magicaldave";
    repo = "S3LightFixes";
    rev = finalAttrs.version;
    hash = "sha256-C8LicGZQGdIzrihAwRwYJNCp73J+XXcyMtde3TgU9Sc=";
  };

  cargoHash = "sha256-3K/rTYykbWD1/4w8KoY//8m4ld9NSBFdoSLNkH6NxHs=";
})
