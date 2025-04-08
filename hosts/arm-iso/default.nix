{
  pkgs,
  modulesPath,
  lib,
  config,
  ...
}:

{
  imports = [

    ./../../nixosModules/minimal
  ];

  sops.enable = false;
  localization.enable = false;

  system.activationScripts.copySecrets.text = ''
    cp -p ${/run/secrets/wifi.env} /wifi.env
    cp -p ${/home/avie/.config/sops/age/keys.txt} /keys.txt
  '';

  environment.shellAliases = {
    dotfiles-clone = "git clone https://github.com/Avie238/dotfiles";
    format-nixos = "mkfs.ext4 -L nixos /dev/disk/by-label/nixos";
    install = "nixos-install --flake ./dotfiles#avie-nixos";
    mount-filesystems = "mount /dev/disk/by-label/nixos /mnt && mkdir -p /mnt/boot && mount /dev/disk/by-label/EFI\\x20-\\x20NIXOS /mnt/boot";
  };

  #Users
  users.users.avie.initialHashedPassword = "";
  users.users.nixos.enable = false;
  nix.settings.trusted-users = lib.mkForce [ "avie" ];

  #Network
  networking.wireless.enable = false;
  networking.networkmanager.ensureProfiles.environmentFiles = lib.mkForce [ "/wifi.env" ];
}
