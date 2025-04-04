# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  pkgs,
  modulesPath,
  lib,
  ...
}:

{
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
    ./../shared/minimal
  ];

  nixpkgs.hostPlatform = "x86_64-linux";

  networking.wireless.enable = lib.mkForce false;

  isoImage.contents = [
    {
      source = ../../../../../run/secrets/wifi.env;
      target = "/secrets/wifi.env";
    }
    {
      source = ../../../../../home/avie/.config/sops/age;
      target = "/age";
    }
  ];

  system.activationScripts.mybootstrap.text = ''
    cp -r /iso/secrets /run
    touch /home/avie/.zshrc
  '';

  environment.shellAliases = { 
    custom-install = ''
    git clone https://github.com/Avie238/dotfiles
    cd dotfiles
    sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode destroy,format,mount /home/avie/dotfiles/nixos/hosts/msi/disko.nix --arg device '"/dev/nvme0n1"'
    nixos-install --flake ./#msi-nixos
    ''
  };

  sops_config.enable = false;
  nix.settings.trusted-users = lib.mkForce [ "avie" ];
  networking.networkmanager.ensureProfiles.environmentFiles = lib.mkForce [ "/run/secrets/wifi.env" ];
  services.getty.autologinUser = lib.mkForce "avie";
  users.users.avie.initialHashedPassword = "";
  services.getty.helpLine = lib.mkForce ''
    Custom installer enviorment from Avie238
  '';

}
