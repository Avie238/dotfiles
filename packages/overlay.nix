final: prev: {
  widevine-firefox = final.callPackage ./widevine-firefox.nix {};
  pokemon-colorscripts = final.callPackage ./pokemon-colorscripts.nix {};
  umo = final.callPackage ./umo.nix {};
  momw-configurator = final.callPackage ./momw-configurator.nix {};
  openmw = final.callPackage ./openmw.nix {};
}
