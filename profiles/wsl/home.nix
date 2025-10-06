{
  lib,
  userSettings,
  ...
}: {
  imports = [
    (userSettings.dotfilesDir + "/user")
  ];

  discord.enable = false;
  openmw-dev.enable = lib.mkForce false;
}
