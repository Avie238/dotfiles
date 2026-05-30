{
  userSettings,
  lib,
  ...
}: {
  imports = [
    (userSettings.dotfilesDir + "/user/shell")
    (userSettings.dotfilesDir + "/user/app/editor/nvim")
  ];

  home.stateVersion = lib.mkForce "26.05";
}
