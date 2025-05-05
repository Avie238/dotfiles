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
      enable = !userSettings.isIso;
      powerOnBoot = !userSettings.isIso;
    };
    services.blueman.enable = !userSettings.isIso;
    #Wifi
    programs.nm-applet.enable = !userSettings.isIso;

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
      wireplumber.extraConfig = {"wireplumber.settings" = {"device.routes.default-sink-volume" = 0;};};
    };

    #Trash bin
    services.gvfs.enable = !userSettings.isIso;

    #Keyring
    security.pam.services.sddm.enableGnomeKeyring = !userSettings.isIso;
    services.gnome.gnome-keyring.enable = !userSettings.isIso;
  };
}
