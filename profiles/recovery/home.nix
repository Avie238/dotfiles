{userSettings, ...}: {
  imports = [
    (userSettings.dotfilesDir + "/user/shell")
    (userSettings.dotfilesDir + "/user/wm")
    (userSettings.dotfilesDir + "/user/app/terminal")
  ];
}
