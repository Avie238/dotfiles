{
  lib,
  pkgs,
  userSettings,
  inputs,
  ...
}:

{
  config = lib.mkIf (userSettings.wm == "hyprland") {
    services = {
      displayManager = {
        sddm = {
          enable = true;
          autoLogin.relogin = true;
          wayland = {
            enable = true;
          };
        };
      };
    };

    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
      withUWSM = true;
    };

    services.xserver.excludePackages = [ pkgs.xterm ];
    hardware.bluetooth.enable = true;
    hardware.bluetooth.powerOnBoot = true;
    services.blueman.enable = true;
    programs.nm-applet.enable = true;
    xdg.portal = {
      enable = true;
    };

    security.pam.services.hyprlock = { };

  };

}
