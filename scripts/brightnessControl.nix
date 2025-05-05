{pkgs}: let
  brightnessctl = "${pkgs.brightnessctl}/bin/brightnessctl";
  notify-send = "${pkgs.libnotify}/bin/notify-send";
in
  pkgs.writeShellScriptBin "brightnessControl" ''
    icon="󰃟 "
    while getopts "idk" flag; do

      case $flag in
      k)
        device="-d kbd_backlight"
        icon="󰌌 "
        ;;
      i)
        value="10%+"
        ;;
      d)
        value="10%-"
        ;;
      \?)
        echo "Invalid option: -$OPTARG"
        exit 1
        ;;
      esac
    done
    ${brightnessctl} $device s $value
    ${notify-send} -t 1500 $icon -h int:value:$(${brightnessctl} -m $device | cut -d',' -f4)

  ''
