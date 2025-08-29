{userSettings, ...}: {
  imports = [
    (userSettings.dotfilesDir + "/system/minimal")
    (userSettings.dotfilesDir + "/system/server")
    (userSettings.dotfilesDir + "/system/desktop/stylix.nix")
  ];
  programs.git = {
    enable = true;
    userName = "Avie238";
    userEmail = "ania.dymowska238@gmail.com";
  };
}
