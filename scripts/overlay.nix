final: prev: {
  pokefetch = final.callPackage ./pokefetch.nix {};
  volumeControl = final.callPackage ./volumeControl.nix {};
  brightnessControl = final.callPackage ./brightnessControl.nix {};
  nix-cleanup = final.callPackage ./nix-cleanup.nix {};
  # runtimeShell = prev.zsh;
}
