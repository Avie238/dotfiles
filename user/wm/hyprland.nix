{
  pkgs,
  config,
  userSettings,
  lib,
  ...
}:

{
  config = lib.mkIf (userSettings.wm == "hyprland") {
    wayland.windowManger.hyprland = {
      enable = true;
      settings = { };
    };

  };
}
