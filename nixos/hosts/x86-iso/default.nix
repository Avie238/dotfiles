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
    ./../shared/sops.nix
    ./../shared/network.nix
    ./../shared/users.
    ./../shared/localization.nix
  ];

  nixpkgs.hostPlatform = "x86_64-linux";

  networking.wireless.enable = lib.mkForce false;

  isoImage.contents = [
    {
      source = ../../../../../../home/avie/.config/sops/age;
      target = "/ania";
    }
  ];

  system.activationScripts.mybootstrap.text = ''
    if [[ ! -e /ania ]]; then
      cp -r ${../../../../../../home/avie/.config/sops/age} /ania
    fi
  '';

  isoImage.makeUsbBootable = true;

  environment.systemPackages = with pkgs; [
    tree
    git
  ];

  # system.activationScripts.mybootstrap = {
  #   text = ''

  #     cp /home/avie/.config/sops/age.keys.txt /age

  #   '';
  # };

}
