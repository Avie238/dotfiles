{
  pkgs,
  userSettings,
  ...
}: {
  imports = [
    ./gnome.nix
    ./hyprland.nix
  ];

  services.xserver = {
    enable = true;
    excludePackages = [pkgs.xterm];
  };

  services.displayManager.autoLogin = {
    enable =
      if userSettings.wm == "none"
      then false
      else true;
    user = "avie";
  };

  #Fix autologin
  systemd.services."getty@tty1".enable =
    if userSettings.wm == "none"
    then true
    else false;
  systemd.services."autovt@tty1".enable =
    if userSettings.wm == "none"
    then true
    else false;
}
