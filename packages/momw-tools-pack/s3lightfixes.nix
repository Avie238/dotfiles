{
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "s3lightfixes";
  version = "0.4.58";

  src = fetchFromGitHub {
    owner = "magicaldave";
    repo = "S3LightFixes";
    rev = finalAttrs.version;
    hash = "sha256-e/CeXOFVAJH7vazlflC68DrwKZQzl8UzklvYLplubbI=";
  };

  cargoHash = "sha256-wjk41yowWpgRLyu84tjDvqqhtjsJvZdaZOYYdP04ZdE=";
})
