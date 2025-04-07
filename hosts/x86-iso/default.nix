{
  pkgs,
  modulesPath,
  lib,
  config,
  ...
}:

{
  imports = [
    (modulesPath + "/profiles/minimal.nix")
    (modulesPath + "/profiles/installation-device.nix")
    (modulesPath + "/installer/cd-dvd/iso-image.nix")
    ./../../nixosModules/minimal
  ];

  # hardware.enableAllHardware = true;
  sops.enable = false;
  localization.enable = false;

  # isoImage.contents = [
  #   {
  #     source = /run/secrets/wifi.env;
  #     target = "/secrets/wifi.env";
  #   }
  #   {
  #     source = /home/avie/.config/sops/age;
  #     target = "/age";
  #   }
  # ];

  system.activationScripts.copySecrets.text = ''
    cp -p ${/run/secrets/wifi.env} /wifi.env
    cp -p ${/home/avie/.config/sops/age/keys.txt} /keys.txt
  '';

  # cp ${"/home/avie/.config/sops/age/keys.txt"} /home/avie/.config/sops/age/

  environment.shellAliases = {
    clone = "git clone https://github.com/Avie238/dotfiles && cd dotfiles";
    partition = "sudo nix run github:nix-community/disko/latest -- --mode destroy,format,mount /home/avie/dotfiles/hosts/msi/disko.nix --arg device \'\"/dev/nvme0n1\"\' --yes-wipe-all-disks";
    copy = "mkdir -p /mnt/var/lib/sops-nix && cp /keys.txt /mnt/var/lib/sops-nix/keys.txt";
    install = "nixos-install --flake ./#msi-nixos --no-root-passwd";
    custom-install = "clone; partition; copy; install";
  };

  # An installation media cannot tolerate a host config defined file
  # system layout on a fresh machine, before it has been formatted.
  swapDevices = lib.mkImageMediaOverride [ ];
  fileSystems = lib.mkImageMediaOverride config.lib.isoFileSystems;

  #Users
  users.users.avie.initialHashedPassword = "";
  users.users.nixos.enable = false;
  nix.settings.trusted-users = lib.mkForce [ "avie" ];

  #Network
  networking.wireless.enable = false;
  networking.networkmanager.ensureProfiles.environmentFiles = lib.mkForce [ "/wifi.env" ];

  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "25.05";

  #Debug
  isoImage.compressImage = false;
  isoImage.squashfsCompression = null;

}
