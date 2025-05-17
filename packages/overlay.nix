final: prev: {
  widevine-firefox = final.callPackage ./widevine-firefox.nix {};
  pokemon-colorscripts = final.callPackage ./pokemon-colorscripts.nix {};
  umo = final.callPackage ./umo.nix {};
  momw-configurator = final.callPackage ./momw-tools-pack/momw-configurator.nix {};
  openmw = final.callPackage ./morrowind/openmw.nix {};
  collada-dom = final.callPackage ./morrowind/collada-dom.nix {};
  openscenegraph = final.callPackage ./morrowind/openscenegraph.nix {};
  delta-plugin = final.callPackage ./momw-tools-pack/delta-plugin.nix {};
}
