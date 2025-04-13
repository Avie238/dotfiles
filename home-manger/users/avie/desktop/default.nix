{
  config,
  pkgs,
  inputs,
  lib,
  desktop,
  ...
}:

{
  imports = [
    ../minimal
    ./vscode
    ./firefox.nix
    ./gnome.nix
  ];

  xdg.autostart.enable = true;

  home.packages = with pkgs; [
    jetbrains.idea-ultimate
    qbittorrent
    nixd
  ];
}
