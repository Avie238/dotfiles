{pkgs}:
pkgs.writeShellApplication {
  name = "volumeControl";
  runtimeInputs = with pkgs; [wireplumber libnotify bc];
  text = ''
    isMuted=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -c MUTED || true)

    if [ "$isMuted" -ge 1 ]; then
      wpctl set-mute @DEFAULT_AUDIO_SINK@ 0
    else
      while getopts "idm" flag; do
        case $flag in
        i)
            wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
            ;;
          d)
            wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
            ;;
          m)
            wpctl set-mute @DEFAULT_AUDIO_SINK@ 1
            exit 1
            ;;
          \?)
            echo "Invalid option: -$OPTARG"
            exit 1
            ;;
          esac
        done
      fi
  '';
}
