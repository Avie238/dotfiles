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
      nautilus
      hypridle
      hyprlock
    ];

    gtk.cursorTheme = {
      package = pkgs.quintom-cursor-theme;
      name = "Quintom_Ink";
      size = 36;
    };

    wayland.windowManager.hyprland = {
      enable = true;
      extraConfig = ''
        exec-once = dbus-update-activation-environment --systemd DISPLAY XAUTHORITY WAYLAND_DISPLAY XDG_SESSION_DESKTOP=Hyprland XDG_CURRENT_DESKTOP=Hyprland XDG_SESSION_TYPE=wayland
        exec-once = ${userSettings.term} & ${userSettings.editor}
        exec-once = sleep 3 && ${userSettings.browser}
        exec-once = hyprctl setcursor ${config.gtk.cursorTheme.name} ${builtins.toString config.gtk.cursorTheme.size}
        exec-once = hypridle & waybar
        exec-once = wpctl set-mute @DEFAULT_AUDIO_SINK@ 1

        env = XCURSOR_SIZE,2n4
        env = HYPRCURSOR_SIZE,24
        env = ELECTRON_OZONE_PLATFORM_HINT,auto
        env = XDG_CURRENT_DESKTOP,Hyprland
        env = XDG_SESSION_DESKTOP,Hyprland
        env = XDG_SESSION_TYPE,wayland
        env = GDK_BACKEND,wayland,x11,*
        env = QT_QPA_PLATFORM,wayland;xcb
        env = QT_QPA_PLATFORMTHEME,qt5ct
        env = QT_AUTO_SCREEN_SCALE_FACTOR,1
        env = QT_WAYLAND_DISABLE_WINDOWDECORATION,1
        env = CLUTTER_BACKEND,wayland

        source = ${userSettings.dotfilesDir}/user/wm/hyprland.conf
        monitor = internal,2560x1664@60,0x0,1

        input {
            kb_layout = ${userSettings.kb_layout}
            
            touchpad  {
            natural_scroll = true
            clickfinger_behavior = true
            }
        }

        $mainMod = SUPER

        bind = $mainMod, Q, killactive,
        bind = SUPERSHIFT, Q, exit,
        bind = $mainMod, E, exec, ${userSettings.editor}
        bind = $mainMod, B, exec, ${userSettings.browser}
        bind = $mainMod, T, exec, ${userSettings.term}

        bind = $mainMod, $mainMod_L, exec, pkill ${userSettings.menu} || ${userSettings.menu_spawn}

        bind = CTRL SHIFT, 3, exec, grim -o "$(hyprctl monitors -j | jq -r '.[] | select(.focused) | .name')" - | wl-copy
        bind = CTRL SHIFT, 4, exec,  grim -g "$(slurp -d)" - | wl-copy

        bind = $mainMod, Right, workspace, +1
        bind = $mainMod, Left, workspace, -1

        # Switch workspaces with mainMod + [0-9]
        bind = $mainMod, 1, workspace, 1
        bind = $mainMod, 2, workspace, 2
        bind = $mainMod, 3, workspace, 3
        bind = $mainMod, 4, workspace, 4
        bind = $mainMod, 5, workspace, 5
        bind = $mainMod, 6, workspace, 6
        bind = $mainMod, 7, workspace, 7
        bind = $mainMod, 8, workspace, 8
        bind = $mainMod, 9, workspace, 9
        bind = $mainMod, 0, workspace, 10

        # Move active window to a workspace with mainMod + SHIFT + [0-9]
        bind = $mainMod SHIFT, 1, movetoworkspace, 1
        bind = $mainMod SHIFT, 2, movetoworkspace, 2
        bind = $mainMod SHIFT, 3, movetoworkspace, 3
        bind = $mainMod SHIFT, 4, movetoworkspace, 4
        bind = $mainMod SHIFT, 5, movetoworkspace, 5
        bind = $mainMod SHIFT, 6, movetoworkspace, 6
        bind = $mainMod SHIFT, 7, movetoworkspace, 7
        bind = $mainMod SHIFT, 8, movetoworkspace, 8
        bind = $mainMod SHIFT, 9, movetoworkspace, 9
        bind = $mainMod SHIFT, 0, movetoworkspace, 10

        bindl=,switch:on:Lid Switch,exec, systemctl suspend

        #Disable MMB
        bind = , mouse:274, exec, 

        windowrule = workspace 1, class:^(${userSettings.term})$,title:^(${userSettings.term})$
        windowrule = workspace 2,class:^(${userSettings.editor})$
        windowrule = workspace empty,class:^(${userSettings.browser})$

        # Ignore maximize requests from apps. You'll probably like this.
        windowrule = suppressevent maximize, class:.*

        # Fix some dragging issues with XWayland
        windowrule = nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0

        misc {
            force_default_wallpaper = 2
        }

        gestures {
            workspace_swipe = true
            workspace_swipe_distance = 150
        }
      '';
      xwayland.enable = true;
      systemd.enable = true;
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
