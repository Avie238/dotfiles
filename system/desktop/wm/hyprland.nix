{
  lib,
  pkgs,
  userSettings,
  inputs,
  ...
}: {
  config = lib.mkIf (userSettings.wm == "hyprland") {
    services.displayManager.sddm = {
      enable = true;
      autoLogin.relogin = true;
      wayland.enable = true;
    };

    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
      withUWSM = true;
    };

    #Bluetooth
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    services.blueman.enable = true;

    #Wifi
    programs.nm-applet.enable = true;

    xdg.portal.enable = true;

    security.pam.services.hyprlock = {};

    # Pipewire
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };

    #Trash bin
    services.gvfs.enable = true;

    #Keyring
    security.pam.services.sddm.enableGnomeKeyring = true;
    services.gnome.gnome-keyring.enable = true;
  };
}
