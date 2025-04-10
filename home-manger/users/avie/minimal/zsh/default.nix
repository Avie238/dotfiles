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
      fastfetch
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
  };

  home.sessionVariables = {
    VISUAL = "code --wait";
    EDITOR = "${config.home.sessionVariables.VISUAL}";
  };

  home.file.".hushlogin" = {
    text = "";
  };

}
