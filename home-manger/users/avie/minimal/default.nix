{
  config,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    ./zsh
    ./fastfetch.nix
    ./git.nix
  ];

  home.username = "avie";
  home.homeDirectory = "/home/avie";

  home.packages = with pkgs; [
    meslo-lgs-nf
    jetbrains-mono
    sops
    any-nix-shell
  ];

  home.stateVersion = "24.11";

  programs.home-manager.enable = true;
}
