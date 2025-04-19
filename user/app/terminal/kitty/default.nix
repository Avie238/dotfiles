{ pkgs, lib, ... }:

{

  programs.kitty = {
    enable = true;
    # font = {
    #   name = "MesloLGS NF";
    #   package = pkgs.meslo-lgs-nf;
    # };
    settings = {
      background_opacity = lib.mkForce 0.85;
    };
  };
  xdg.autostart.entries = [
    "${pkgs.kitty}/share/applications/kitty.desktop"
  ];

}
