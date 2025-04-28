{
  lib,
  userSettings,
  ...
}:

{
  config = lib.mkIf (userSettings.wm == "gnome") {

    services.xserver = {
      displayManager.gdm.enable = true;
      displayManager.gdm.wayland = true;
      desktopManager.gnome.enable = true;
    };

    qt = {
      enable = true;
      platformTheme = "gnome";
      style = "adwaita-dark";
    };
  };
}
