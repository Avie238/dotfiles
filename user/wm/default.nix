{ config, ... }:

{
  imports = [
    ./gnome.nix
    ./hyprland.nix
  ];

  systemd.user.sessionVariables = config.home.sessionVariables;

}
