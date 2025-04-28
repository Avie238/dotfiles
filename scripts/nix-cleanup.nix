{ pkgs }:

pkgs.writeShellScriptBin "nix-cleanup" ''
  while getopts "f" flag; do
   case $flag in
     f)
      nix-collect-garbage  --delete-old && sudo nix-collect-garbage -d
     ;;
   esac
  done
  nix-store --gc
''
