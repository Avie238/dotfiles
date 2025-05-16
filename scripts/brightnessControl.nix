{pkgs}:
pkgs.writeShellApplication {
  name = "brightnessControl";
  excludeShellChecks = ["SC2086"];

  runtimeInputs = with pkgs; [brightnessctl libnotify];
  text = ''
    device=""
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
    brightnessctl $device s $value
    notify-send -t 1500 $icon -h int:value:"$(brightnessctl -m $device | cut -d',' -f4)"

  '';
}
