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
      grim
      slurp
      wl-clipboard
      jq
      brightnessctl
      hypridle
      pamixer
      lxqt.pavucontrol-qt
      networkmanagerapplet
      hyprnome
      xfce.thunar
      hyprpaper
      hyprpicker
      grimblast
    ];

    wayland.windowManager.hyprland = {
      enable = true;
      settings = {
        exec-once = [
          "dbus-update-activation-environment --systemd DISPLAY XAUTHORITY WAYLAND_DISPLAY XDG_SESSION_DESKTOP=Hyprland XDG_CURRENT_DESKTOP=Hyprland XDG_SESSION_TYPE=wayland"
          "wpctl set-mute @DEFAULT_AUDIO_SINK@ 1"
          "[workspace 1 silent] uwsm app -- ${userSettings.term}"
          "[workspace 2 silent] uwsm app -- ${userSettings.editor}"
          "[workspace 3 silent] uwsm app -- ${userSettings.browser}"
        ];

        env = [
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
            "SUPERSHIFT, Q, exec, uwsm stop"
            "$mainMod, E, exec, uwsm app -- ${userSettings.editor}"
            "$mainMod, T, exec, uwsm app -- ${userSettings.term}"
            "$mainMod, $mainMod_L, exec, pkill ${userSettings.menu} || ${userSettings.menu_spawn}"
            "CTRL SHIFT, 3, exec, grimblast --freeze copysave output"
            "CTRL SHIFT, 4, exec, grimblast --freeze copysave area"
            "SUPERSHIFT, P, exec, hyprpicker --autocopy --format=hex"
            "$mainMod, Left, exec, hyprnome --previous"
            "$mainMod, Right, exec, hyprnome"
            "SUPER_SHIFT, Left, exec, hyprnome --previous --move"
            "SUPER_SHIFT, Right, exec, hyprnome --move"
            #Disable MMB
            ", mouse:274, exec,"
            "SUPER, RETURN, exec, if hyprctl clients | grep scratch_term; then echo \"scratch_term respawn not needed\"; else uwsm app -- kitty --class scratch_term; fi"
            "SUPER, RETURN, togglespecialworkspace,scratch_term"
            "SUPER, L, exec, if hyprctl clients | grep scratch_files; then echo \"scratch_files respawn not needed\"; else uwsm app -- ${userSettings.fileManager}; fi"
            "SUPER, L, togglespecialworkspace,scratch_files"
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

        "$scratchpadsize" = "size 80% 85%";

        "$scratch_term" = "class:^(scratch_term)$";
        "$scratch_files" = "class:^(${userSettings.fileManager})$";

        windowrulev2 = [
          "float,$scratch_term"
          "$scratchpadsize,$scratch_term"
          "workspace special:scratch_term ,$scratch_term"
          "float,$scratch_files"
          "$scratchpadsize,$scratch_files"
          "workspace special:scratch_files ,$scratch_files"
        ];

        bindl = [
          ",switch:on:Lid Switch,exec, systemctl suspend"
        ];

        bindel = [
          ",XF86AudioRaiseVolume, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ 0 && wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
          ",XF86AudioLowerVolume, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ 0 && wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
          ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
          ",XF86MonBrightnessUp, exec, brightnessctl s 10%+"
          ",XF86MonBrightnessDown, exec, brightnessctl s 10%-"
        ];

        windowrule = [
          "workspace empty,class:^(vesktop)$"
          "float, title:^(Volume Control|Bluetooth Devices|Network Connections)$"
          "size 50% 50%, title:^(Volume Control|Bluetooth Devices|Network Connections)$"
          "suppressevent maximize, class:.*"
          "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"
        ];

        workspace = [
          #Auto open firefox on new workspace
          "r[3-6], on-created-empty:[] firefox"
        ];

        ecosystem = {
          no_update_news = true;
        };

        gestures = {
          workspace_swipe = true;
          workspace_swipe_distance = 150;
        };

        general = {
          gaps_in = 5;
          gaps_out = 7;
          border_size = 3;

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
            "specialWorkspace, 1, 4, default, slidefadevert -50%"

          ];
        };
      };

      xwayland.enable = true;
      systemd.enable = false;
    };

    programs.hyprlock = {
      enable = true;
      settings = with config.lib.stylix.colors; {
        background = {
          blur_passes = 2;
          contrast = 1;
          brightness = 0.5;
          vibrancy = 0.2;
          vibrancy_darkness = 0.2;
        };

        input-field = {
          size = "20%, 5%";
          outline_thickness = 3;
          placeholder_text = "<i>Password</i>";

          fade_on_empty = false;
          rounding = 15;

          position = "0, -20";
          halign = "center";
          valign = "center";
        };

        label = [
          {
            text = "$TIME";
            color = "rgb(${base05})";
            font_size = 95;
            font_family = "${userSettings.font} Extrabold";
            position = "0, 130";
            halign = "center";
            valign = "center";
          }
          {
            text = ''cmd[update:1000] echo "$(date +"%A, %B %d")"'';
            color = "rgb(${base05})";
            font_size = 22;
            font_family = userSettings.font;
            position = "0, 230";
            halign = "center";
            valign = "center";
          }
        ];

      };
    };

    programs.waybar = {
      enable = true;
      systemd.enable = true;
      settings.mainBar = {
        layer = "bottom";
        position = "top";
        reload_style_on_change = true;
        modules-left = [
          "group/power"
          "custom/right-arrow-dark"
          "custom/right-arrow-light"
          "clock"
          "custom/right-arrow-dark"
          "custom/right-arrow-light"
          "hyprland/workspaces"
          "custom/right-arrow-dark"
        ];
        modules-right = [
          "custom/left-arrow-dark"
          "pulseaudio"
          "custom/left-arrow-light"
          "custom/left-arrow-dark"
          "memory"
          "custom/left-arrow-light"
          "custom/left-arrow-dark"
          "cpu"
          "custom/left-arrow-light"
          "custom/left-arrow-dark"
          "temperature"
          "custom/left-arrow-light"
          "custom/left-arrow-dark"
          "group/backlight"
          "custom/left-arrow-light"
          "custom/left-arrow-dark"
          "battery"
          "custom/left-arrow-light"
          "custom/left-arrow-dark"
          "tray"
        ];
        "group/power" = {
          orientation = "horizontal";
          drawer = {
            transition-duration = 500;
            children-class = "not-power";
            transition-left-to-right = true;
          };
          modules = [
            "custom/os"
            "custom/logout"
            "custom/lock"
            "custom/power"
            "custom/reboot"
          ];
        };
        "custom/os" = {
          format = "  ";
          tooltip = false;
        };
        "custom/logout" = {
          format = " 󰍃 ";
          tooltip = false;
          on-click = "uwsm stop";
        };
        "custom/lock" = {
          format = "󰍁 ";
          tooltip = false;
          on-click = "hyprlock";
        };
        "custom/reboot" = {
          format = "󰜉 ";
          tooltip = false;
          on-click = "reboot";
        };
        "custom/power" = {
          format = "󰐥 ";
          tooltip = false;
          on-click = "shutdown now";
        };
        "custom/left-arrow-dark" = {
          format = "";
          tooltip = false;
        };
        "custom/left-arrow-light" = {
          format = "";
          tooltip = false;
        };
        "custom/right-arrow-dark" = {
          format = "";
          tooltip = false;
        };
        "custom/right-arrow-light" = {
          format = "";
          tooltip = false;
        };
        backlight = {
          format = "{icon}";
          format-icons = [
            ""
            ""
            ""
            ""
            ""
            ""
            ""
            ""
            ""
          ];
        };
        "backlight#text" = {
          format = "{percent}%";
        };
        "group/backlight" = {
          orientation = "horizontal";
          drawer = {
            transition-duration = 500;
            transition-left-to-right = true;
          };
          modules = [
            "backlight"
            "backlight#text"
          ];
        };

        "hyprland/workspaces" = {
          disable-scroll = true;
          format = "{icon}";
        };
        clock = {
          format = " {:%H:%M}";
        };
        pulseaudio = {
          format = "{volume}% {icon} ";
          format-bluetooth = "{volume}% {icon} ";
          format-muted = "󰖁 ";
          format-icons = {
            default = [
              ""
              ""
            ];
          };
          scroll-step = 1;
          on-click = "pavucontrol-qt";
        };
        memory = {
          interval = 5;
          format = "Mem {}%";
        };
        cpu = {
          interval = 5;
          format = "CPU {usage:2}%";
        };
        battery = {
          states = {
            good = 95;
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}%";
          format-charging = "󱐋 {capacity}%";
          format-icons = [
            ""
            ""
            ""
            ""
            ""
          ];
        };
        tray = {
          icon-size = 20;
        };
        temperature = {
          format = "{temperatureC}°C  ";
        };
      };
      style = with config.lib.stylix.colors.withHashtag; ''
        * {
          font-size: 15px;
          font-family: monospace;
        }

        window#waybar {
          background: ${base00};
        }

        #custom-right-arrow-dark,
        #custom-left-arrow-dark {
          color: ${base01};
          font-size: 20px;
        }
        #custom-right-arrow-light,
        #custom-left-arrow-light {
          color: ${base00};
          background: ${base01};
          font-size: 20px;
        }

        #workspaces,
        #clock,
        #pulseaudio,
        #memory,
        #cpu,
        #battery,
        #disk,
        #tray,
        #temperature,
        #backlight,
        #custom-os,
        .not-power {
          background: ${base01};
        }

        #workspaces button {
          padding: 0 2px;
          color: ${base06};

        }
        #workspaces button.active {
          color: ${base03};
          background:  ${base00};
        }
        #workspaces button:hover {
          box-shadow: inherit;
          text-shadow: inherit;
        }
        #workspaces button:hover {
          background:  ${base00};
          border:  ${base00};
          padding: 0 3px;
        }

        #pulseaudio {
          color: #268bd2;
        }
        #memory {
          color: #2aa198;
        }
        #cpu {
          color: #6c71c4;
        }
        #battery {
          color: #859900;
        }
        #battery.warning {
          color: #b58900;
        }
        #battery.critical {
          color: #9c0425;
        }


        #pulseaudio,
        #memory,
        #cpu,
        #battery,
        #disk,
        #temperature,
        #tray,
        #backlight{
          padding-right: 10px;
        }
        #clock,
        #workspaces {
          padding-left: 10px;
        }

        #custom-os,
        #custom-quit,
        #custom-lock,
        #custom-reboot,
        #custom-logout,
        #custom-power {
          font-size: 18px;
        }
      '';
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

    programs.rofi = {
      enable = true;
      package = pkgs.rofi-wayland;
    };

    services.hyprpaper.enable = true;

  };

}
