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
    ./network.nix
    ./users.nix
    ./sops.nix
    ./terminal.nix
  ];

  sops_config.enable = lib.mkDefault true;

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    tree
    git
    nodejs
    nixfmt-rfc-style
    gparted
  ];

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    download-buffer-size = 524288000;
  };

}
