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
    (userSettings.dotfilesDir + "/profiles/${userSettings.profile}/configuration.nix")
  ];

  environment.shellAliases = {
    partition = "sudo nix run github:nix-community/disko/latest -- --mode destroy,format,mount /home/avie/dotfiles/hosts/msi/disko.nix --arg device \'\"/dev/nvme0n1\"\' --yes-wipe-all-disks";
    copy = "sudo mkdir -p /mnt/var/lib/sops-nix && sudo cp /keys.txt /mnt/var/lib/sops-nix/keys.txt";
    install = "sudo nixos-install --flake ./#msi-nixos --no-root-passwd";
    install-server = "sudo nixos-install --flake ./#msi-nixos-server --no-root-passwd";
    custom-install = "clone; partition; copy; install";
  };

  swapDevices = lib.mkImageMediaOverride [];
  fileSystems = lib.mkImageMediaOverride config.lib.isoFileSystems;

  nixpkgs.hostPlatform = userSettings.system;
  system.stateVersion = "25.05";

  #Debug
  # isoImage.compressImage = false;
  # isoImage.squashfsCompression = null;
}
