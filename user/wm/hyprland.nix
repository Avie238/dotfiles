{
  pkgs,
  config,
  userSettings,
  lib,
  ...
}:

{
  config = lib.mkIf (userSettings.wm == "hyprland") {

    home.packages = with pkgs; [
      rofi-wayland
      grim
      slurp
      wl-clipboard
      jq
      brightnessctl
      hypridle
      hyprlock
      pamixer
      lxqt.pavucontrol-qt
      networkmanagerapplet
      blueman
      hyprnome
      xfce.thunar
      hyprpaper
    ];

    home.pointerCursor = {
      gtk.enable = true;
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 20;
      # package = pkgs.quintom-cursor-theme;
      # name = "Quintom_Ink";
      # size = 21;
    };

    gtk = {
      enable = true;

      theme = {
        package = pkgs.flat-remix-gtk;
        name = "Flat-Remix-GTK-Grey-Darkest";
      };

      # theme = {
      #   name = "Adwaita-dark";
      #   package = pkgs.gnome-themes-extra;
      # };

      iconTheme = {
        package = pkgs.adwaita-icon-theme;
        name = "Adwaita";
      };

      font = {
        name = "Sans";
        size = 11;
      };
    };

    wayland.windowManager.hyprland = {
      enable = true;
      settings = {
        exec-once = [
          "dbus-update-activation-environment --systemd DISPLAY XAUTHORITY WAYLAND_DISPLAY XDG_SESSION_DESKTOP=Hyprland XDG_CURRENT_DESKTOP=Hyprland XDG_SESSION_TYPE=wayland"
          "hyprpaper & hypridle & waybar & blueman-applet & nm-applet --indicator"
          "hyprctl setcursor ${config.home.pointerCursor.name} ${builtins.toString config.home.pointerCursor.size}"
          "${userSettings.term} & ${userSettings.editor}"
          "sleep 2 && ${userSettings.browser}"
          "wpctl set-mute @DEFAULT_AUDIO_SINK@ 1"
        ];

        env = [
          "XCURSOR_SIZE,24"
          "HYPRCURSOR_SIZE,24"
          "ELECTRON_OZONE_PLATFORM_HINT,auto"
          "XDG_CURRENT_DESKTOP,Hyprland"
          "XDG_SESSION_DESKTOP,Hyprland"
          "XDG_SESSION_TYPE,wayland"
          "GDK_BACKEND,wayland,x11,*"
          "QT_QPA_PLATFORM,wayland;xcb"
          "QT_QPA_PLATFORMTHEME,qt5ct"
          "QT_AUTO_SCREEN_SCALE_FACTOR,1"
          "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
          "CLUTTER_BACKEND,wayland"
        ];

        monitor = "internal,2560x1664@60,0x0,1";

        input = {
          kb_layout = userSettings.kb_layout;

          touchpad = {
            natural_scroll = true;
            clickfinger_behavior = true;
          };
        };

        "$mainMod" = "SUPER";

        bind =
          [
            "$mainMod, Q, killactive,"
            "SUPERSHIFT, Q, exit,"
            "$mainMod, E, exec, ${userSettings.editor}"
            "$mainMod, B, exec, ${userSettings.browser}"
            "$mainMod, T, exec, ${userSettings.term}"
            "$mainMod, $mainMod_L, exec, pkill ${userSettings.menu} || ${userSettings.menu_spawn}"
            "CTRL SHIFT, 3, exec, grim -o \"$(hyprctl monitors -j | jq -r '.[] | select(.focused) | .name')\" - | wl-copy"
            "CTRL SHIFT, 4, exec,  grim -g \"$(slurp -d)\" - | wl-copy"
            "$mainMod, Left, exec, hyprnome --previous"
            "$mainMod, Right, exec, hyprnome"
            "SUPER_SHIFT, Left, exec, hyprnome --previous --move"
            "SUPER_SHIFT, Right, exec, hyprnome --move"
            #Disable MMB
            ", mouse:274, exec,"
          ]
          ++ (

            builtins.concatLists (
              builtins.genList (
                i:
                let
                  ws = i + 1;
                in
                [
                  "$mainMod, code:1${toString i}, workspace, ${toString ws}"
                  "$mainMod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
                ]
              ) 9
            )
          );

        bindl = [
          ",switch:on:Lid Switch,exec, systemctl suspend"
        ];

        bindel = [
          ",XF86AudioRaiseVolume, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ 0 && wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
          ",XF86AudioLowerVolume, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ 0 && wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
          ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ 1"
          ",XF86MonBrightnessUp, exec, brightnessctl s 10%+"
          ",XF86MonBrightnessDown, exec, brightnessctl s 10%-"
        ];

        windowrule = [
          "workspace 1, class:^(${userSettings.term})$,title:^(${userSettings.term})$"
          "workspace 2,class:^(${userSettings.editor})$"
          "workspace empty,class:^(${userSettings.browser})$"
          # Ignore maximize requests from apps. You'll probably like this.
          "suppressevent maximize, class:.*"
          # Fix some dragging issues with XWayland
          "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"

        ];

        ecosystem = {
          no_update_news = true;
        };

        gestures = {
          workspace_swipe = true;
          workspace_swipe_distance = 150;
        };

        misc = {
          force_default_wallpaper = 2;
        };

        general = {
          gaps_in = 5;
          gaps_out = 7;
          border_size = 2;
          "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
          "col.inactive_border" = "rgba(595959aa)";

          resize_on_border = false;
          allow_tearing = false;

          layout = "dwindle";
        };

        decoration = {
          rounding = 10;
          rounding_power = 2;

          active_opacity = 1.0;
          inactive_opacity = 1.0;

          shadow = {
            enabled = true;
            range = 4;
            render_power = 3;
            color = "rgba(1a1a1aee)";
          };

          blur = {
            enabled = true;
            size = 3;
            passes = 1;

            vibrancy = 0.1696;
          };
        };

        dwindle = {
          pseudotile = true;
          preserve_split = true;
        };

        master = {
          new_status = "master";
        };

        animations = {
          enabled = true;

          bezier = [
            "easeOutQuint,0.23,1,0.32,1"
            "easeInOutCubic,0.65,0.05,0.36,1"
            "linear,0,0,1,1"
            "almostLinear,0.5,0.5,0.75,1.0"
            "quick,0.15,0,0.1,1"
          ];
          animation = [
            "global, 1, 10, default"
            "border, 1, 5.39, easeOutQuint"
            "windows, 1, 4.79, easeOutQuint"
            "windowsIn, 1, 4.1, easeOutQuint, popin 87%"
            "windowsOut, 1, 1.49, linear, popin 87%"
            "fadeIn, 1, 1.73, almostLinear"
            "fadeOut, 1, 1.46, almostLinear"
            "fade, 1, 3.03, quick"
            "layers, 1, 3.81, easeOutQuint"
            "layersIn, 1, 4, easeOutQuint, fade"
            "layersOut, 1, 1.5, linear, fade"
            "fadeLayersIn, 1, 1.79, almostLinear"
            "fadeLayersOut, 1, 1.39, almostLinear"
          ];
        };
      };

      xwayland.enable = true;
      systemd.enable = false;
    };

    programs.hyprlock = {
      enable = true;
      settings = {
        background = {
          path = "${userSettings.dotfilesDir}/wallpaper.png";
          color = "rgba(25, 20, 20, 1.0)";
          blur_passes = 2;
        };

        input-field = {
          size = "20%, 5%";
          outline_thickness = 3;
          inner_color = "rgba(0, 0, 0, 0.0)"; # no fill

          outer_color = "rgba(33ccffee) rgba(00ff99ee) 45deg";
          check_color = "rgba(00ff99ee) rgba(ff6633ee) 120deg";
          fail_color = "rgba(ff6633ee) rgba(ff0066ee) 40deg";

          font_color = "rgb(143, 143, 143)";
          fade_on_empty = false;
          rounding = 15;

          position = "0, -20";
          halign = "center";
          valign = "center";
        };
      };
    };

    services.hyprpaper = {
      enable = true;
      settings = {
        preload = "${userSettings.dotfilesDir}/wallpaper.png";
        wallpaper = ", ${userSettings.dotfilesDir}/wallpaper.png";
      };
    };

    programs.waybar = {
      enable = true;
      settings.mainBar = (builtins.fromJSON (builtins.readFile ./waybar/config.jsonc));
      style = builtins.toString (builtins.readFile ./waybar/style.css);
    };

    services.hypridle = {
      enable = true;
      settings = {
        general = {
          lock_cmd = "pidof hyprlock || hyprlock";
          before_sleep_cmd = "loginctl lock-session";
          after_sleep_cmd = "hyprctl dispatch dpms on";
        };

        listener = [
          {
            timeout = 150;
            on-timeout = "brightnessctl -s set 0";
            on-resume = "brightnessctl -r";
          }
          {
            timeout = 150;
            on-timeout = "brightnessctl -sd rgb:kbd_backlight set 0";
            on-resume = "brightnessctl -rd rgb:kbd_backlight";
          }
          {
            timeout = 330;
            on-timeout = "hyprctl dispatch dpms off";
            on-resume = "hyprctl dispatch dpms on && brightnessctl -r";
          }
          {
            timeout = 1000;
            on-timeout = "systemctl suspend";
          }

        ];
      };
    };

  };

}
