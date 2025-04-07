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

}
