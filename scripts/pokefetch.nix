{pkgs}:
pkgs.writeShellApplication {
  name = "pokefetch";
  excludeShellChecks = ["SC2086"];
  runtimeInputs = with pkgs; [pokemon-colorscripts fastfetch];
  text = ''
    name='-rn lunala,noivern,palkia,espeon,sylveon,corviknight,tapu-fini,goodra'
    while getopts "n:" flag; do
     case $flag in
       n)
        name="-n $OPTARG"
        ;;
       \?)
        echo "Invalid option: -$OPTARG"
        exit 1
        ;;
     esac
    done
    fastfetch --logo "$(pokemon-colorscripts $name --no-title)" --logo-type data
  '';
}
