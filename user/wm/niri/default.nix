{
  pkgs,
  lib,
  userSettings,
  config,
  ...
}: {
  config = lib.mkIf (userSettings.wm == "niri") {
    gtk.iconTheme = {
      package = pkgs.papirus-icon-theme;
      name = "Papirus-Dark";
    };
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
    ];

    waybar.enable = true;

    services.hyprpaper.enable = true;
    hyprland.hyprlock = true;
    hyprland.hypridle = true;

    services.dunst.enable = true;

    programs.niri.settings = {
      input.focus-follows-mouse.enable = false;
      outputs."eDP-1" = {
        scale = 2;
        mode = {
          height = 1664;
          width = 2560;
          refresh = 60.0;
        };
      };

      layout = {
        gaps = 3;
        struts.bottom = 2;
        border = {
          enable = true;
          width = 3;
        };
      };
      prefer-no-csd = true;

      xwayland-satellite.enable = true;

      binds = with config.lib.niri.actions; {
        #Volume and brightness
        "XF86AudioRaiseVolume" = {
          action = spawn "volumeControl" "-i";
          allow-when-locked = true;
          hotkey-overlay = {
            hidden = true;
          };
        };
        "XF86AudioLowerVolume" = {
          action = spawn "volumeControl" "-d";
          allow-when-locked = true;
          hotkey-overlay = {
            hidden = true;
          };
        };
        "XF86AudioMute" = {
          action = spawn "volumeControl" "-m";
          allow-when-locked = true;
          hotkey-overlay = {
            hidden = true;
          };
        };
        "XF86MonBrightnessUp" = {
          action = spawn "brightnessControl" "-i";
          allow-when-locked = true;
          hotkey-overlay = {
            hidden = true;
          };
        };
        "XF86MonBrightnessDown" = {
          action = spawn "brightnessControl" "-d";
          allow-when-locked = true;
          hotkey-overlay = {
            hidden = true;
          };
        };
        "Mod+XF86MonBrightnessUp" = {
          action = spawn "brightnessControl" "-i" "-k";
          allow-when-locked = true;
          hotkey-overlay = {
            hidden = true;
          };
        };
        "Mod+XF86MonBrightnessDown" = {
          action = spawn "brightnessControl" "-d" "-k";
          allow-when-locked = true;
          hotkey-overlay = {
            hidden = true;
          };
        };
        "XF86Fn" = {
          action = spawn "${pkgs.fn-toggle}/bin/fn-toggle";
          allow-when-locked = true;
          hotkey-overlay = {
            hidden = true;
          };
        };

        "Mod+Q".action = close-window;
        "Mod+T" = {
          action = spawn "${userSettings.term}";
          hotkey-overlay = {
            title = "Spawn terminal";
          };
        };
        "Mod+E" = {
          action = spawn-sh "${userSettings.editor.spawn}";
          hotkey-overlay = {
            title = "Spawn editor";
          };
        };
        "Mod+L" = {
          action = spawn-sh "${userSettings.fileManager.spawn}";
          hotkey-overlay = {
            title = "Spawn file manager";
          };
        };
        "Mod+Space" = {
          action = spawn-sh "${userSettings.menu.spawn}";
          hotkey-overlay = {
            title = "Spawn app menu";
          };
        };
        "Mod+D".action = toggle-overview;
        "Super+Super_L".action = close-overview;
        "Mod+Period".action = show-hotkey-overlay;
        "Mod+F".action = maximize-column;

        "Mod+Shift+E".action = quit;
        "Mod+Ctrl+Shift+E".action = quit {skip-confirmation = true;};

        "Mod+Left".action = focus-column-left;
        "Mod+Right".action = focus-column-right;
        "Mod+Shift+Left".action = move-column-left;
        "Mod+Shift+Right".action = move-column-right;

        #Workspaces
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

      window-rules = [
        {
          matches = [
            {app-id = userSettings.term;}
          ];
          excludes = [
            {title = "vim*";}
          ];
          opacity = 0.85;
        }
        {
          matches = [
            {
              title = "vim*";
              app-id = userSettings.term;
            }
          ];
          opacity = 0.95;
        }
        {
          matches = [
            {
              app-id = "fuzzel";
            }
          ];
          open-focused = true;
        }
      ];
      switch-events = with config.lib.niri.actions; {
        lid-close.action = spawn "";
      };

      # Asahi specific
      debug = lib.mkIf (userSettings.host == "asahi") {
        render-drm-device = "/dev/dri/renderD128";
      };
    };
  };
}
