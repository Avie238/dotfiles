{
  lib,
  pkgs,
  userSettings,
  inputs,
  ...
}:

{
  config = lib.mkIf (userSettings.wm == "hyprland") {

    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    };

    services.xserver.excludePackages = [ pkgs.xterm ];

    environment.systemPackages = with pkgs; [
      waybar
      rofi-wayland
      grim
      slurp
      wl-clipboard
      kdePackages.dolphin
      jq
    ];

    xdg.portal = {
      enable = true;
    };
  };
}
