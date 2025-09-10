{userSettings, ...}: {
  imports = [
    (userSettings.dotfilesDir + "/user")
  ];

  discord.enable = false;
}
