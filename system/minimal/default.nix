{
  pkgs,
  lib,
  inputs,
  userSettings,
  config,
  ...
}: {
  imports = [
    inputs.sops-nix.nixosModules.sops
    ./localization.nix
    ./network.nix
    ./users.nix
    ./sops.nix
    ./terminal.nix
    ./ssh.nix
  ];

  boot.loader = {
    systemd-boot.enable = true;
    timeout = lib.mkForce 2;
    efi.canTouchEfiVariables = lib.mkDefault true;
  };
  boot.supportedFilesystems = ["apfs" "ntfs"];

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
    gparted
  ];
}
