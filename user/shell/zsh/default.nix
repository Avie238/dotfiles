{ config, pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    plugins = [
      {
        name = "powerlevel10k-config";
        src = ./.;
        file = ".p10k.zsh";
      }
      {
        name = "zsh-powerlevel10k";
        src = "${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/";
        file = "powerlevel10k.zsh-theme";
      }
    ];

    initExtraFirst = ''
      any-nix-shell zsh --info-right | source /dev/stdin
      fastfetch --logo "$(pokemon-colorscripts -rn lunala,noivern,palkia,espeon,sylveon,corviknight,tapu-fini,goodra --no-title)" --logo-type data
      if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
        source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
      fi
    '';

    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "sudo"
      ];
    };

  };

  home.shellAliases = {
    code = "codium";
    iso_arm = "nix build .#installer-bootstrap -o results/iso-asahi -j6 -L --impure";
    iso_x86 = "nix run nixpkgs\#nixos-generators --  --format iso --flake ./#msi-iso -o results/iso-msi --system x86_64-linux";
    nrs = "sudo nixos-rebuild switch --flake ./#";
    pokefetch = "fastfetch --logo \"$(pokemon-colorscripts -rn lunala,noivern,palkia,espeon,sylveon,corviknight,tapu-fini,goodra --no-title)\" --logo-type data";
  };

  home.sessionVariables = {
    VISUAL = "codium --wait";
    EDITOR = "${config.home.sessionVariables.VISUAL}";
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
  };

  home.file.".hushlogin" = {
    text = "";
  };

}
