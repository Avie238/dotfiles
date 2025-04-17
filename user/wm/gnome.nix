{
  pkgs,
  config,
  userSettings,
  lib,
  ...
}:

{
  config = lib.mkIf (userSettings.wm == "gnome") {
    dconf = {
      enable = true;
      settings = {
        "org/gnome/desktop/interface" = {
          show-battery-percentage = true;
        };
        "org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
        };
      };

    };

    gtk = {
      enable = true;
      theme = {
        name = "Adwaita-dark";
        package = pkgs.gnome-themes-extra;
      };
    };
  };
}
