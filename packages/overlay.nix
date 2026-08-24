final: prev: {
  jackify = final.callPackage ./jackify.nix {};
  widevine-firefox = final.callPackage ./widevine-firefox.nix {};
  pokemon-colorscripts = final.callPackage ./pokemon-colorscripts.nix {};
  umo = final.callPackage ./momw-tools-pack/umo.nix {};
  momw-configurator = final.callPackage ./momw-tools-pack/momw-configurator.nix {};
  delta-plugin = final.callPackage ./momw-tools-pack/delta-plugin.nix {};
  s3lightfixes = final.callPackage ./momw-tools-pack/s3lightfixes.nix {};
  openmw-validator = final.callPackage ./momw-tools-pack/openmw-validator.nix {};
  groundcoverify = final.callPackage ./momw-tools-pack/groundcoverify.nix {};
  tor-browser = final.callPackage ./tor-browser.nix {};
  hakuneko = final.callPackage ./hakuneko.nix {};
  qrookie = final.callPackage ./qrookie.nix {};
  fex-emu-wine = final.callPackage ./fex-emu-wine.nix {};
  wine-wow64-fex = final.callPackage ./wine-wow64-fex.nix {};
  serena-mcp = final.callPackage ./serena-mcp.nix {};
}
