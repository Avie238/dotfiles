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

  home.packages = with pkgs; [
    brightnessctl
    networkmanagerapplet
    hyprnome
    hyprpaper
    (userSettings.fileManager.package)
    grimblast
    hyprsunset
    cmatrix
    cava
    btop
    baobab
    dunst
    nix-cleanup
    volumeControl
    brightnessControl
    unar
    # xfce.thunar
  ];

  # Asahi specific
  programs.niri.settings.debug = lib.mkIf (userSettings.host == "asahi") {
    render-drm-device = "/dev/dri/renderD128";
  };
  # programs.niri = {
  #   config = builtins.readFile ./config.kdl;
  # };
  programs.niri.settings.binds = with config.lib.niri.actions; {
    "XF86AudioRaiseVolume".action = spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1+";
    "XF86AudioLowerVolume".action = spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1-";

    "Mod+Q".action = close-window;
    "Mod+T".action = spawn "${userSettings.term}";
    "Mod+E".action = spawn-sh "${userSettings.editor.spawn}";
    "Mod+Return".action = spawn-sh "pkill fuzzel || fuzzel";
    "Mod+D".action = toggle-overview;
    "Mod+Period".action = show-hotkey-overlay;
    "Mod+F".action = maximize-column;

    "Mod+Shift+E".action = quit;
    "Mod+Ctrl+Shift+E".action = quit {skip-confirmation = true;};

    "Mod+Plus".action = set-column-width "+10%";

    "Mod+Left".action = focus-column-left;
    "Mod+Right".action = focus-column-right;
    "Mod+Shift+Left".action = move-column-left;
    "Mod+Shift+Right".action = move-column-right;

    "Mod+1".action.focus-workspace = 1;
    "Mod+2".action.focus-workspace = 2;
    "Mod+3".action.focus-workspace = 3;
    "Mod+4".action.focus-workspace = 4;
    "Mod+5".action.focus-workspace = 5;
    "Mod+6".action.focus-workspace = 6;
    "Mod+7".action.focus-workspace = 7;
    "Mod+8".action.focus-workspace = 8;
    "Mod+9".action.focus-workspace = 9;

    "Mod+Shift+1".action.move-column-to-workspace = 1;
    "Mod+Shift+2".action.move-column-to-workspace = 2;
    "Mod+Shift+3".action.move-column-to-workspace = 3;
    "Mod+Shift+4".action.move-column-to-workspace = 4;
    "Mod+Shift+5".action.move-column-to-workspace = 5;
    "Mod+Shift+6".action.move-column-to-workspace = 6;
    "Mod+Shift+7".action.move-column-to-workspace = 7;
    "Mod+Shift+8".action.move-column-to-workspace = 8;
    "Mod+Shift+9".action.move-column-to-workspace = 9;
  };
  # };
}
