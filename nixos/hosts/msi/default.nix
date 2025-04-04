# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ./../shared/desktop
    (import ./disko.nix { device = "/dev/nvme0n1"; })
  ];

  networking.hostName = "msi-nixos";

  system.stateVersion = "25.05";

}
