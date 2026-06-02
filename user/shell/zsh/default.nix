{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.zsh = {
    enable = true;
    dotDir = "${config.xdg.configHome}/zsh";
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

    initContent = lib.mkBefore ''
      any-nix-shell zsh --info-right | source /dev/stdin
      pokefetch
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
    nsr = "sudo nixos-rebuild switch --flake ./#";
    nix-rebuild = "sudo nixos-rebuild switch --flake ~/dotfiles/#";
    nix-update = "nix flake update && nix-rebuild";
    rebuild = "sudo nixos-rebuild switch --flake ./#";
    nix-list = "nixos-rebuild list-generations";
    cd = "z";
    cat = "bat";
  };

  home.sessionVariables = {
    VISUAL = "nvim";
    EDITOR = "${config.home.sessionVariables.VISUAL}";
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
    NIXPKGS_ALLOW_UNFREE = 1;
    LD_LIBRARY_PATH = "${pkgs.stdenv.cc.cc.lib}/lib/";
  };

  home.file.".hushlogin" = {
    text = "";
  };
}
