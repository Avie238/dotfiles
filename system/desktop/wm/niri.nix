{
  lib,
  pkgs,
  userSettings,
  inputs,
  ...
}: {
  config = lib.mkIf (userSettings.wm == "niri") {
    # services.displayManager.sddm = {
    #   enable = true;
    #   # autoLogin.relogin = true;
    #   wayland.enable = true;
    # };

    services.displayManager.gdm = {
      enable = true;
      settings = {
        daemon = {
          AutomaticLoginEnable = true;
          AutomaticLogin = "avie";
        };
      };
    };

    programs.niri = {
      enable = true;
    };

    #Bluetooth
    hardware.bluetooth = {
      enable = !userSettings.isIso;
      powerOnBoot = !userSettings.isIso;
    };
    services.blueman.enable = !userSettings.isIso;

    #Wifi
    programs.nm-applet.enable = !userSettings.isIso;

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
    environment.systemPackages = with pkgs; [
      fuzzel
      alacritty
    ];
    services.displayManager.defaultSession = "niri";
  };
}
