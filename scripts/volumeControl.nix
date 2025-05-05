{pkgs}: let
  wpctl = "${pkgs.wireplumber}/bin/wpctl";
  notify-send = "${pkgs.libnotify}/bin/notify-send";
  bc = "${pkgs.bc}/bin/bc";
in
  pkgs.writeShellScriptBin "volumeControl" ''
    isMuted="$(${wpctl} get-volume @DEFAULT_AUDIO_SINK@ | grep -c MUTED)"

    while getopts "idm" flag; do
      case $flag in
      i)
        if [ $isMuted -ge 1 ]; then
          ${wpctl} set-mute @DEFAULT_AUDIO_SINK@ 0
        else
          ${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 5%+
        fi
        ${notify-send} -t 1500 " " -h int:value:$(echo "$(${wpctl} get-volume @DEFAULT_AUDIO_SINK@ | cut -d' ' -f2) * 100" | ${bc})
        exit 1
        ;;
      d)
        if [ $isMuted -ge 1 ]; then
          ${wpctl} set-mute @DEFAULT_AUDIO_SINK@ 0
        else
          ${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 5%-
        fi
        ${notify-send} -t 1500 " " -h int:value:$(echo "$(${wpctl} get-volume @DEFAULT_AUDIO_SINK@ | cut -d' ' -f2) * 100" | ${bc})
        exit 1
        ;;
      m)
        if [ $isMuted -ge 1 ]; then
          ${wpctl} set-mute @DEFAULT_AUDIO_SINK@ 0

          ${notify-send} -t 1500 " " -h int:value:$(echo "$(${wpctl} get-volume @DEFAULT_AUDIO_SINK@ | cut -d' ' -f2) * 100" | ${bc})

        else
          ${wpctl} set-mute @DEFAULT_AUDIO_SINK@ 1
          ${notify-send} -t 1500 " " -h int:value:0
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
