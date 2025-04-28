{
  modulesPath,
  lib,
  config,
  userSettings,
  ...
}: {
  imports = [
    (modulesPath + "/profiles/minimal.nix")
    (modulesPath + "/profiles/installation-device.nix")
    (modulesPath + "/installer/cd-dvd/iso-image.nix")
    ./../../../system/iso
  ];

  environment.shellAliases = {
    partition = "sudo nix run github:nix-community/disko/latest -- --mode destroy,format,mount /home/avie/dotfiles/hosts/msi/disko.nix --arg device \'\"/dev/nvme0n1\"\' --yes-wipe-all-disks";
    install = "sudo nixos-install --flake ./#msi-nixos --no-root-passwd";
    custom-install = "clone; partition; copy; install";
  };

  # An installation media cannot tolerate a host config defined file
  # system layout on a fresh machine, before it has been formatted.
  swapDevices = lib.mkImageMediaOverride [];
  fileSystems = lib.mkImageMediaOverride config.lib.isoFileSystems;

  nixpkgs.hostPlatform = userSettings.system;
  system.stateVersion = "25.05";

  #Debug
  isoImage.compressImage = false;
  isoImage.squashfsCompression = null;
}
