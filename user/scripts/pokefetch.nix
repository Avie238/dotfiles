{ pkgs }:

pkgs.writeShellScriptBin "pokefetch" ''
  ${pkgs.fastfetch}/bin/fastfetch --logo "$(${pkgs.nur.repos.Ex-32.pokemon-colorscripts}/bin/pokemon-colorscripts -rn lunala,noivern,palkia,espeon,sylveon,corviknight,tapu-fini,goodra --no-title)" --logo-type data
''
