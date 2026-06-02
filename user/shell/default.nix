{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./zsh
    ./fastfetch.nix
    ./git.nix
  ];

  home.username = "avie";
  home.homeDirectory = lib.mkForce "/home/avie";

  home.packages = with pkgs; [
    meslo-lgs-nf
    jetbrains-mono
    sops
    any-nix-shell
  ];

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs = {
    ripgrep.enable = true;
    fd.enable = true;
    tmux = {
      enable = true;
    };
    bat.enable = true;
  };

  programs.lazydocker.enable = true;

  home.stateVersion = "24.11";

  programs.home-manager.enable = true;
}
