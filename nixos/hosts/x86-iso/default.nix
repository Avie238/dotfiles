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
      source = ../../../../../../run/secrets/wifi.env;
      target = "/secrets/wifi.env";
    }
    {
      source = ../../../../../../home/avie/.config/sops/age;
      target = "/age";
    }
  ];

  system.activationScripts.mybootstrap.text = ''
    cp -r /iso/secrets /run
    touch /home/nixos/.zshrc
  '';

  isoImage.makeUsbBootable = true;

  # sops.secrets."user_passwords/avie".neededForUsers = lib.mkForce false;
  # users.users.avie = {

  #   hashedPasswordFile = lib.mkForce null;
  # };

  # sops.secrets."wifi.env" = lib.mkForce { };

}
