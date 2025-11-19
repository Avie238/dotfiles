{
  userSettings,
  config,
  lib,
  ...
}: {
  imports = [
    (userSettings.dotfilesDir + "/profiles/${userSettings.profile}/configuration.nix")
  ];

  boot.binfmt.emulatedSystems = ["i686-linux" "x86_64-linux"];
  nix.settings.extra-platforms = config.boot.binfmt.emulatedSystems;

  environment.shellAliases = {
    format-nixos = "mkfs.ext4 -L nixos /dev/disk/by-label/nixos";
    mount-filesystems = "sudo mount /dev/disk/by-label/nixos /mnt && sudo mkdir -p /mnt/boot && sudo mount '/dev/disk/by-label/EFI\x20-\x20NIXOS' /mnt/boot";
    copy = "sudo mkdir -p /mnt/home/avie/.config/sops/age && sudo cp /keys.txt /mnt/home/avie/.config/sops/age";
    install = "nixos-install --flake ./dotfiles#avie-nixos --no-root-passwd";
    custom-install = "clone; format-nixos; mount-filesystems; copy; install";
  };

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";
}
