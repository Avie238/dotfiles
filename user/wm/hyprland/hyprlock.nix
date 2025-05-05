{
  config,
  userSettings,
  lib,
  ...
}: {
  options = {
    hyprland.hyprlock = lib.mkOption {
      default = userSettings.wm == "hyprland";
      type = lib.types.bool;
    };
  };

  config = lib.mkIf config.hyprland.hyprlock {
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
            font_family = "${userSettings.font.name} Extrabold";
            position = "0, 130";
            halign = "center";
            valign = "center";
          }
          {
            text = ''cmd[update:1000] echo "$(date +"%A, %B %d")"'';
            color = "rgb(${base05})";
            font_size = 22;
            font_family = userSettings.font.name;
            position = "0, 230";
            halign = "center";
            valign = "center";
          }
        ];
      };
    };
  };
}
