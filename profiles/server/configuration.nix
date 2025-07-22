{userSettings, ...}: {
  imports = [
    (userSettings.dotfilesDir + "/system/minimal/ssh.nix")
    (userSettings.dotfilesDir + "/system/minimal/users.nix")
    (userSettings.dotfilesDir + "/system/minimal/sops.nix")
    (userSettings.dotfilesDir + "/system/server")
  ];
}
