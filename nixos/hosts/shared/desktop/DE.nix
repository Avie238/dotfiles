{ config, pkgs, ... }:
{
  services.displayManager.autoLogin = {
    enable = true;
    user = "avie";
  };

  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    displayManager.gdm.wayland = true;
    desktopManager.gnome.enable = true;
  };
}
