{userSettings, ...}: {
  imports = [
    (userSettings.dotfilesDir + "/user")
  ];

  gaming.enable = true;

  openmw-dev.enable = true;
}
