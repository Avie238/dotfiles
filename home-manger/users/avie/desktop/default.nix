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
    ./vscode
    ./firefox.nix
    ./gnome.nix
  ];

  xdg.autostart.enable = true;

}
