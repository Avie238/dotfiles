{ pkgs, ... }:

{

  programs.firefox = {
    enable = true;
  };
  xdg.autostart.entries = [
    "${pkgs.firefox}/share/applications/firefox.desktop"
  ];

}
