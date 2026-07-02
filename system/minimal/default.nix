{
  lib,
  inputs,
  userSettings,
  ...
}: {
  imports = [
    ./localization.nix
    ./network.nix
    ./users.nix
    ./sops.nix
    ./terminal.nix
    ./ssh.nix
  ];

  boot.loader = {
    # grub.enable = true;
    timeout = lib.mkForce 2;
    efi.canTouchEfiVariables = lib.mkDefault true;
  };
  boot.supportedFilesystems = ["ntfs" "exfat"];

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    download-buffer-size = 524288000;
    extra-substituters = (import ../../flake.nix).nixConfig.extra-trusted-substituters;
    extra-trusted-public-keys = (import ../../flake.nix).nixConfig.extra-trusted-public-keys;
  };
  nix.nixPath = ["nixpkgs=${inputs.nixpkgs}"];

  system.autoUpgrade = {
    enable = true;
    flake = "/home/avie/dotfiles";
    flags = [
      "--print-build-logs"
    ];
    dates = "09:00";
    randomizedDelaySec = "45min";
  };

  networking.hostName = userSettings.hostname;
}
