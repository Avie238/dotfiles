{
  lib,
  userSettings,
  ...
}: {
  config = lib.mkIf (userSettings.wm == "gnome") {
    services.xserver = {
      displayManager.gdm.enable = true;
      displayManager.gdm.wayland = true;
      desktopManager.gnome.enable = true;
    };

    # qt = {
    #   enable = true;
    #   platformTheme = "gnome";
    #   style = "adwaita-dark";
    # };
    services.displayManager.autoLogin = {
      enable = true;
      user = "avie";
    };

    #Fix autologin
    systemd.services."getty@tty1".enable = false;
    systemd.services."autovt@tty1".enable = false;
  };
}
