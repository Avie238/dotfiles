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

  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

}
