{config, ...}: {
  imports = [
    ./gnome.nix
    ./hyprland
  ];

  systemd.user.sessionVariables = config.home.sessionVariables;
}
