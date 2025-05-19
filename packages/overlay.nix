final: prev: {
  widevine-firefox = final.callPackage ./widevine-firefox.nix {};
  pokemon-colorscripts = final.callPackage ./pokemon-colorscripts.nix {};
  umo = final.callPackage ./momw-tools-pack/umo.nix {};
  momw-configurator = final.callPackage ./momw-tools-pack/momw-configurator.nix {};
  openmw-dev = final.callPackage ./morrowind/openmw-dev.nix {};
  collada-dom = final.callPackage ./morrowind/collada-dom.nix {};
  openscenegraph = final.callPackage ./morrowind/openscenegraph.nix {};
  delta-plugin = final.callPackage ./momw-tools-pack/delta-plugin.nix {};
  s3lightfixes = final.callPackage ./momw-tools-pack/s3lightfixes.nix {};
  openmw-validator = final.callPackage ./momw-tools-pack/openmw-validator.nix {};
  groundcoverify = final.callPackage ./momw-tools-pack/groundcoverify.nix {};
}
