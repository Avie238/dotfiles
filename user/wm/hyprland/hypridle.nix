{
  pkgs,
  config,
  lib,
  userSettings,
  ...
}: {
  options = {
    hyprland.hypridle = lib.mkOption {
      default = userSettings.wm == "hyprland";
      type = lib.types.bool;
    };
  };

  config = lib.mkIf config.hyprland.hypridle {
    home.packages = with pkgs; [
      hypridle
      brightnessctl
    ];

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
