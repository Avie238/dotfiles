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

  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;
}
