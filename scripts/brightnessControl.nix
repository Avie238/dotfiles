{pkgs}:
pkgs.writeShellScriptBin "brightnessControl" ''
  while getopts "id" flag; do
    case $flag in
    i)
      ${pkgs.brightnessctl}/bin/brightnessctl s 10%+
      ;;
    d)
      ${pkgs.brightnessctl}/bin/brightnessctl s 10%-
      ;;
    \?)
      echo "Invalid option: -$OPTARG"
      exit 1
      ;;
    esac
    ${pkgs.libnotify}/bin/notify-send -t 1500 "󰃟 " -h int:value:$(${pkgs.brightnessctl}/bin/brightnessctl -m | cut -d',' -f4)
  done
''
