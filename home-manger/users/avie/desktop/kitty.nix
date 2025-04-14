{ pkgs, ... }:

{

  programs.kitty = {
    enable = true;
    font = {
      name = "MesloLGS NF";
      package = pkgs.meslo-lgs-nf;
    };
  };
  xdg.autostart.entries = [
    "${pkgs.kitty}/share/applications/kitty.desktop"
  ];

}
