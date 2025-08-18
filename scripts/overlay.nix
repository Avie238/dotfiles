final: prev: {
  pokefetch = final.callPackage ./pokefetch.nix {};
  volumeControl = final.callPackage ./volumeControl.nix {};
  brightnessControl = final.callPackage ./brightnessControl.nix {};
  nix-cleanup = final.callPackage ./nix-cleanup.nix {};
  fn-toggle = final.callPackage ./fn-toggle.nix {};
  cbz_to_webp = final.callPackage ./cbz_to_webp.nix {};
}
