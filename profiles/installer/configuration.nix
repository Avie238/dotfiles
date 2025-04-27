{userSettings, ...}: {
  imports = [
    (userSettings.dotfilesDir + "/nixosModules/minimal")
  ];
}
