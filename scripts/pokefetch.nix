{pkgs}:
pkgs.writeShellScriptBin "pokefetch" ''
  name="-rn lunala,noivern,palkia,espeon,sylveon,corviknight,tapu-fini,goodra"
  while getopts "n:" flag; do
   case $flag in
     n)
     name="-n $OPTARG"
      exit 1
      ;;
     \?)
      echo "Invalid option: -$OPTARG"
      exit 1
      ;;
   esac
  done
  ${pkgs.fastfetch}/bin/fastfetch --logo "$(${pkgs.nur.repos.Ex-32.pokemon-colorscripts}/bin/pokemon-colorscripts $name --no-title)" --logo-type data
''
