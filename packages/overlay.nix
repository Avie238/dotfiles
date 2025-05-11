final: prev: {
  widevine-firefox = final.callPackage ./widevine-firefox.nix {};
  pokemon-colorscripts = final.callPackage ./pokemon-colorscripts.nix {};
}
