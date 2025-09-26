{userSettings, ...}: {
  imports = [
    (userSettings.dotfilesDir + "/user/shell")
    (userSettings.dotfilesDir + "/user/app/editor/nvim")
    # (userSettings.dotfilesDir + "/user/app/shell")
  ];
}
