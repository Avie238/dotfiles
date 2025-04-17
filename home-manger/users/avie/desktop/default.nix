{ pkgs, ... }:

{
  imports = [
    ../minimal
    ./vscode
    ./firefox.nix
    ./gnome.nix
    ./kitty.nix
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
