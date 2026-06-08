{userSettings, ...}: {
  imports = [
    (userSettings.dotfilesDir + "/user")
  ];

  gaming.enable = true;
}
