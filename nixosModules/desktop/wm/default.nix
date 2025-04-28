{pkgs, ...}: {
  imports = [
    ./gnome.nix
    ./hyprland.nix
  ];

  services.xserver = {
    enable = true;
    excludePackages = [pkgs.xterm];
  };

  services.displayManager.autoLogin = {
    enable = true;
    user = "avie";
  };

  #Fix autologin
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;
}
