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

  services.kmscon.enable = true;

  isoImage.contents = [
    {
      source = /run/secrets/wifi.env;
      target = "/secrets/wifi.env";
    }
    {
      source = /home/avie/.config/sops/age;
      target = "/age";
    }
  ];

  system.activationScripts.mybootstrap.text = ''
    cp -r /iso/secrets /run
    touch /home/avie/.zshrc
  '';

  environment.shellAliases = {

    clone = ''
      git clone https://github.com/Avie238/dotfiles
      cd dotfiles
    '';

    partition = ''
      sudo nix run github:nix-community/disko/latest -- --mode destroy,format,mount /home/avie/dotfiles/hosts/msi/disko.nix --arg device '"/dev/nvme0n1"' --yes-wipe-all-disks
    '';
    install = ''
      nixos-install --flake ./#msi-nixos --no-root-passwd
    '';
    copy = ''
      cp /iso/age/keys.txt /mnt/var/lib/sops-nix --mkdir
    '';

    custom-install = ''
      sudo su
      clone
      partition
      copy
      install
    '';
  };

  services.getty.helpLine = lib.mkForce ''
    Custom installer enviorment from Avie238
  '';

  console.packages = [ pkgs.terminus_font ];

  # An installation media cannot tolerate a host config defined file
  # system layout on a fresh machine, before it has been formatted.
  swapDevices = lib.mkImageMediaOverride [ ];
  fileSystems = lib.mkImageMediaOverride config.lib.isoFileSystems;

  #Turning stuff off
  users.users.nixos.enable = false;
  sops_config.enable = false;
  localization.enable = false;
  networking.wireless.enable = false;
  nix.settings.trusted-users = lib.mkForce [ "avie" ];
  networking.networkmanager.ensureProfiles.environmentFiles = lib.mkForce [ "/run/secrets/wifi.env" ];
  services.getty.autologinUser = lib.mkForce "avie";
  users.users.avie.initialHashedPassword = "";

  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "25.05";

}
