{ pkgs, ... }:

{
  imports = [
    ./editor
    ./browser
    ./terminal
    ../shell
  ];

  xdg.autostart.enable = true;

  home.packages = with pkgs; [
    jetbrains.idea-ultimate
    qbittorrent
    nixd
    nodejs_23
    python310
  ];
}
