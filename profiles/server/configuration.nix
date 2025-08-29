{userSettings, ...}: {
  imports = [
    (userSettings.dotfilesDir + "/system/minimal")
    (userSettings.dotfilesDir + "/system/server")
    (userSettings.dotfilesDir + "/system/desktop/stylix.nix")
  ];
}
