{
  modulesPath,
  lib,
  pkgs,
  inputs,
  userSettings,
  ...
}: {
  imports = [
    inputs.disko.nixosModules.disko
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")

    # (userSettings.dotfilesDir + "/profiles/${userSettings.profile}/configuration.nix")
    ./disko.nix
    ./hardware-configuration.nix
  ];
  boot.loader.grub = {
    efiSupport = true;
    efiInstallAsRemovable = true;
  };
  services.openssh.enable = true;

  environment.systemPackages = map lib.lowPrio [
    pkgs.curl
    pkgs.gitMinimal
  ];

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEpr1NL5tOxml1z9ZlW0TW6o5d46SG+8lk+z6i4QS1G9 ania.dymowska238@gmail.com"
  ];

  networking.hostName = "avie-vps";
  fileSystems."/nix/store" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "btrfs";
  };

  system.stateVersion = "24.05";
}
