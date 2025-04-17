{
  lib,
  pkgs,
  userSettings,
  ...
}:

{
  config = lib.mkIf (userSettings.wm == "hyprland") {

    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
    };

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
