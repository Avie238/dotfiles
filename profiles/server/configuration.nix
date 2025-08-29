{userSettings, ...}: {
  imports = [
    (userSettings.dotfilesDir + "/system/minimal")
    (userSettings.dotfilesDir + "/system/server")
  ];
}
