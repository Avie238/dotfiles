{ pkgs, lib, ... }:

{

  programs.kitty = {
    enable = true;
  };
  xdg.autostart.entries = [
    "${pkgs.kitty}/share/applications/kitty.desktop"
  ];

}
