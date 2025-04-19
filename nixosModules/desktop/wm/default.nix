{ ... }:

{
  imports = [
    ./gnome.nix
    ./hyprland.nix
  ];

  services.xserver = {
    enable = true;
  };

  services.displayManager.autoLogin = {
    enable = true;
    user = "avie";
  };

  services.xserver.displayManager.lightdm.enable = true;

  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

}
