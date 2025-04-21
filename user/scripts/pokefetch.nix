{ pkgs }:

pkgs.writeShellScriptBin "pokefetch" ''
  while getopts "n:" flag; do
   case $flag in
     n)
      ${pkgs.fastfetch}/bin/fastfetch --logo "$(${pkgs.nur.repos.Ex-32.pokemon-colorscripts}/bin/pokemon-colorscripts -n $OPTARG --no-title)" --logo-type data
      exit 1
      ;;
     \?)
      echo "Invalid option: -$OPTARG"
      exit 1
      ;;
   esac
  done
  ${pkgs.fastfetch}/bin/fastfetch --logo "$(${pkgs.nur.repos.Ex-32.pokemon-colorscripts}/bin/pokemon-colorscripts -rn lunala,noivern,palkia,espeon,sylveon,corviknight,tapu-fini,goodra --no-title)" --logo-type data
''
