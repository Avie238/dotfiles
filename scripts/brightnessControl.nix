{pkgs}:
pkgs.writeShellApplication {
  name = "brightnessControl";
  excludeShellChecks = ["SC2086"];

  runtimeInputs = with pkgs; [brightnessctl libnotify];
  text = ''
    device=""
    while getopts "idk" flag; do

      case $flag in
      k)
        device="-d kbd_backlight"
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
  '';
}
