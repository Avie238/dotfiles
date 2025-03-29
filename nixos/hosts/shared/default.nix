# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:

{
  imports = [
    inputs.sops-nix.nixosModules.sops
    ./localization.nix
    ./DE.nix
    ./network.nix
    ./graphics.nix
    ./users.nix
    ./sops.nix
  ];

  nixpkgs.config.allowUnfree = true;

  nixpkgs.overlays = [
    inputs.nix-vscode-extensions.overlays.default
  ];

  programs.zsh = {
    enable = true;
  };

  users.defaultUserShell = pkgs.zsh;

  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true;
  };

  security.sudo.wheelNeedsPassword = false;

  environment.systemPackages = with pkgs; [
    tree
    firefox
    git
    nodejs
    nixfmt-rfc-style
    dotnet-sdk
    gparted
  ];

  virtualisation.docker.enable = true;

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    download-buffer-size = 524288000;
  };

}
