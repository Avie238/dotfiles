{
  config,
  userSettings,
  lib,
  pkgs,
  ...
}: {
  options = {
    wm.utils.wayle.enable = lib.mkOption {
      default = userSettings.wm == "niri";
      type = lib.types.bool;
    };
  };

  config = lib.mkIf config.wm.utils.hyprlock.enable {
    services.wayle = {
      enable = true;
      package = pkgs.wayle_unstable;
      settings = {
        styling = {
          palette = {
            bg = "#46354a";
            surface = "#241b26";
            elevated = "#2f2a3f";
            fg = "#eed5d9";
            fg-muted = "#241b26";
            primary = "#877bb6";
            red = "#a84a73";
            yellow = "#de5b44";
            green = "#78a38f";
            blue = "#877bb6";
          };
          theme-provider = "wayle";
        };
        bar = {
          bg = "#241b26";
          scale = 0.65;
          padding-ends = 1;
          layout = [
            {
              monitor = "*";
              left = [
                "dashboard"
                "idle-inhibit"
                "clock"
                "weather"
                "niri-workspaces"
              ];
              center = [];
              right =
                [
                  "ram"
                  "cpu"
                ]
                ++ lib.optionals userSettings.battery ["battery"]
                ++ [
                  "bluetooth"
                  "network"
                  "volume"
                  "notifications"
                ];
            }
          ];
          location = "top";
          rounding = "sm";
        };
        modules = {
          clock = {
            format = "%H:%M %a %d %b";
            dropdown-show-seconds = false;
          };
          weather.location = "Maastricht";
        };
      };
    };
  };
}
