{
  pkgs,
  config,
  userSettings,
  lib,
  ...
}: {
  options = {
    hyprland.waybar = lib.mkOption {
      default = userSettings.wm == "hyprland";
      type = lib.types.bool;
    };
  };
  config = lib.mkIf config.hyprland.waybar {
    home.packages = with pkgs; [
      lxqt.pavucontrol-qt
      hyprsysteminfo
    ];

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
          "idle_inhibitor"
          "custom/right-arrow-dark"
          "custom/right-arrow-light"
          "custom/clock"
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
          on-click = "hyprsysteminfo";
        };
        "custom/logout" = {
          format = " 󰍃 ";
          tooltip = false;
          on-click = "uwsm stop";
        };
        "custom/lock" = {
          format = " ";
          tooltip = false;
          on-click = "hyprlock";
        };
        "custom/reboot" = {
          format = " ";
          tooltip = false;
          on-click = "reboot";
        };
        "custom/power" = {
          format = " ";
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
        idle_inhibitor = {
          format = "{icon} ";
          format-icons = {
            "activated" = "";
            "deactivated" = "";
          };
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
        "custom/clock" = {
          exec = "date +\"%H:%M %a %-d %b\"";
          interval = 1;
          on-click = "uwsm app -- ${userSettings.browser} -new-window \"https://calendar.google.com/calendar/u/0/r\"";
          tooltip = false;
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
          tooltip = false;
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
      style = with config.lib.stylix.colors.withHashtag;
      #css
        ''
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
          #custom-clock,
          #pulseaudio,
          #memory,
          #cpu,
          #battery,
          #disk,
          #tray,
          #temperature,
          #backlight,
          #custom-os,
          .not-power,
          #idle_inhibitor{
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

          #custom-clock,
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
  };
}
