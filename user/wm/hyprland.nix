{
  pkgs,
  config,
  userSettings,
  lib,
  ...
}:

{
  options = {
    mainMod = lib.mkOption {
      default = "SUPER";
      type = lib.types.str;
    };
  };
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
      settings = {
        source = "/home/avie/dotfiles/user/wm/hyprland.conf";
      };
      extraConfig = ''
        monitor = internal,2560x1664@60,0x0,1

        exec-once = ${userSettings.term} & ${userSettings.editor} & ${userSettings.browser}
        exec-once = hyprctl setcursor ${config.gtk.cursorTheme.name} ${builtins.toString config.gtk.cursorTheme.size}
        exec-once = hypridle & waybar

        input {
            kb_layout = ${userSettings.kb_layout}
            
            touchpad  {
            natural_scroll = true
            clickfinger_behavior = true
            }
        }

        env = XCURSOR_SIZE,24
        env = HYPRCURSOR_SIZE,24
        env = ELECTRON_OZONE_PLATFORM_HINT,auto

        bind = $mainMod, Q, killactive,
        bind = $mainMod, M, exit,
        bind = $mainMod, E, exec, ${userSettings.editor}
        bind = $mainMod, B, exec, ${userSettings.browser}
        bind = $mainMod, T, exec, ${userSettings.term}

        bind = $mainMod, $mainMod_L, exec, pkill ${userSettings.menu} || ${userSettings.menu_spawn}

        bind = CTRL SHIFT, 3, exec, grim -o "$(hyprctl monitors -j | jq -r '.[] | select(.focused) | .name')" - | wl-copy
        bind = CTRL SHIFT, 4, exec,  grim -g "$(slurp -d)" - | wl-copy

        bind = $mainMod, Right, workspace, +1
        bind = $mainMod, Left, workspace, -1

        windowrule = workspace 1, class:^(${userSettings.term})$,title:^(${userSettings.term})$
        windowrule = workspace 2,class:^(${userSettings.editor})$
        windowrule = workspace empty,class:^(${userSettings.browser})$

        # Ignore maximize requests from apps. You'll probably like this.
        windowrule = suppressevent maximize, class:.*

        # Fix some dragging issues with XWayland
        windowrule = nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0'';
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
