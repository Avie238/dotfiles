{
  pkgs,
  modulesPath,
  lib,
  config,
  inputs,
  ...
}:

{
  imports = [

    (modulesPath + "/profiles/minimal.nix")
    (modulesPath + "/profiles/installation-device.nix")
    (modulesPath + "/installer/cd-dvd/iso-image.nix")
    ./../../../nixosModules/minimal
    inputs.apple-silicon.nixosModules.apple-silicon-support
  ];

  sops.enable = false;
  localization.enable = false;

  system.activationScripts.copySecrets.text = ''
    cp -p ${/run/secrets/wifi.env} /wifi.env
    cp -p ${/home/avie/.config/sops/age/keys.txt} /keys.txt
  '';

  environment.shellAliases = {
    dotfiles-clone = "git clone https://github.com/Avie238/dotfiles && cd dotfiles";
    format-nixos = "mkfs.ext4 -L nixos /dev/disk/by-label/nixos";
    mount-filesystems = "mount /dev/disk/by-label/nixos /mnt && mkdir -p /mnt/boot && mount /dev/disk/by-label/EFI\\x20-\\x20NIXOS /mnt/boot";
    copy = "sudo mkdir -p /mnt/var/lib/sops-nix && sudo cp /keys.txt /mnt/var/lib/sops-nix/keys.txt";
    install = "nixos-install --flake ./dotfiles#avie-nixos --no-root-passwd";
    custom-install = "clone; format-nixos; mount-filesystems; copy; install";
  };

  #Users
  users.users.avie.initialHashedPassword = "";
  users.users.nixos.enable = false;
  nix.settings.trusted-users = lib.mkForce [ "avie" ];

  swapDevices = lib.mkImageMediaOverride [ ];
  fileSystems = lib.mkImageMediaOverride config.lib.isoFileSystems;

  #Network
  networking.wireless.enable = false;
  networking.networkmanager.ensureProfiles.environmentFiles = lib.mkForce [ "/wifi.env" ];

  nixpkgs.hostPlatform = "aarch64-linux";
  system.stateVersion = "25.05";

  isoImage.compressImage = false;
  isoImage.squashfsCompression = null;
}
