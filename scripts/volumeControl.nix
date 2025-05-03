{pkgs}:
pkgs.writeShellScriptBin "volumeControl" ''
  isMuted="$(${pkgs.wireplumber}/bin/wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -c MUTED)"

  while getopts "idm" flag; do
    case $flag in
    i)
      if [ $isMuted -ge 1 ]; then
        ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ 0
        notify-send -t 1500 " " -h int:value:$(($(wpctl get-volume @DEFAULT_AUDIO_SINK@ | cut -d' ' -f2) * 100))
      else
        ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
        notify-send -t 1500 " " -h int:value:$(($(wpctl get-volume @DEFAULT_AUDIO_SINK@ | cut -d' ' -f2) * 100))
      fi
      exit 1
      ;;
    d)
      if [ $isMuted -ge 1 ]; then
        ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ 0
        notify-send -t 1500 " " -h int:value:$(($(wpctl get-volume @DEFAULT_AUDIO_SINK@ | cut -d' ' -f2) * 100))
      else
        ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
        notify-send -t 1500 " " -h int:value:$(($(wpctl get-volume @DEFAULT_AUDIO_SINK@ | cut -d' ' -f2) * 100))
      fi
      exit 1
      ;;
    m)
      if [ $isMuted -ge 1 ]; then
        ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ 0
        A=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | cut -d' ' -f2)
        B=$(echo "$A * 100" | ${pkgs.bc}/bin/bc)

        notify-send -t 1500 " " -h int:value:$B
      else
        ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ 1
        notify-send -t 1500 "󰖁 " -h int:value:0
      fi
      exit 1
      ;;
    \?)
      echo "Invalid option: -$OPTARG"
      exit 1
      ;;
    esac
  done
''
