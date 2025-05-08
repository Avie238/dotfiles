{userSettings, ...}: {
  imports = [
    (userSettings.dotfilesDir + "/profiles/${userSettings.profile}/configuration.nix")
  ];

  environment.shellAliases = {
    format-nixos = "mkfs.ext4 -L nixos /dev/disk/by-label/nixos";
    mount-filesystems = "sudo mount /dev/disk/by-label/nixos /mnt && sudo mkdir -p /mnt/boot && sudo mount /dev/disk/by-label/EFI\\x20-\\x20NIXOS /mnt/boot";
    copy = "sudo mkdir -p /home/avie/.config/sops/age && sudo cp /keys.txt /home/avie/.config/sops/age";
    install = "nixos-install --flake ./dotfiles#avie-nixos --no-root-passwd";
    custom-install = "clone; format-nixos; mount-filesystems; copy; install";
  };
}
