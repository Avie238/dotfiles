{
  userSettings,
  modulesPath,
  lib,
  config,
  ...
}: {
  imports = [
    ./../../../system/iso
    (modulesPath + "/profiles/minimal.nix")
    (modulesPath + "/profiles/installation-device.nix")
    (modulesPath + "/installer/cd-dvd/iso-image.nix")

    (userSettings.dotfilesDir + "/profiles/${userSettings.profile}/configuration.nix")
  ];

  environment.shellAliases = {
    format-nixos = "mkfs.ext4 -L nixos /dev/disk/by-label/nixos";
    mount-filesystems = "mount /dev/disk/by-label/nixos /mnt && mkdir -p /mnt/boot && mount /dev/disk/by-label/EFI\\x20-\\x20NIXOS /mnt/boot";
    install = "nixos-install --flake ./dotfiles#avie-nixos --no-root-passwd";
    custom-install = "clone; format-nixos; mount-filesystems; copy; install";
  };

  swapDevices = lib.mkImageMediaOverride [];
  fileSystems = lib.mkImageMediaOverride config.lib.isoFileSystems;

  nixpkgs.hostPlatform = userSettings.system;
  system.stateVersion = "25.05";

  #Debug
  isoImage.compressImage = false;
  isoImage.squashfsCompression = null;
}
