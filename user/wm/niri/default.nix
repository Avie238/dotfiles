{
  pkgs,
  lib,
  userSettings,
  config,
  ...
}: {
  # config = lib.mkIf (userSettings.wm == "niri") {
  # programs.niri = {
  #   enable = true;
  #   package = pkgs.niri-unstable;
  # };
  # Asahi specific
  programs.niri.settings.debug = lib.mkIf (userSettings.host == "asahi") {
    render-drm-device = "/dev/dri/renderD128";
  };

  programs.niri.settings.binds = with config.lib.niri.actions; {
    "XF86AudioRaiseVolume".action = spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1+";
    "XF86AudioLowerVolume".action = spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1-";

    "Mod+T".action = spawn "kitty";
    "Super+Super_L".action = spawn-sh "pkill fuzzel || fuzzel";
    "Mod+1".action = show-hotkey-overlay;
    "Mod+Q".action = close-window;

    "Mod+Shift+E".action = quit;
    "Mod+Ctrl+Shift+E".action = quit {skip-confirmation = true;};

    "Mod+Plus".action = set-column-width "+10%";
  };
  # };
}
