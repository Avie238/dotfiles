{
  lib,
  pkgs,
  userSettings,
  inputs,
  ...
}:

{
  config = lib.mkIf (userSettings.wm == "hyprland") {
    # services = {
    #   displayManager = {
    #     sddm = {
    #       enable = true;
    #       wayland = {
    #         enable = true;
    #       };
    #     };
    #   };
    # };

    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
      # withUWSM = true;
    };

    services.xserver.excludePackages = [ pkgs.xterm ];
    hardware.bluetooth.enable = true; # enables support for Bluetooth
    hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot
    services.blueman.enable = true;
    xdg.portal = {
      enable = true;
    };

    security.pam.services.hyprlock = { };

  };

}
