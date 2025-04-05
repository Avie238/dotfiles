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
  localization.enable = lib.mkDefault true;

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = lib.mkDefault true;
  };

  nixpkgs.config.allowUnfree = true;

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    download-buffer-size = 524288000;
  };

  virtualisation.docker.enable = true;

  environment.systemPackages = with pkgs; [
    tree
    git
    nixfmt-rfc-style
  ];

}
