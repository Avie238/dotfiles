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
  ];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  # boot.kernelParams = [
  #   "apple_dcp.show_notch=1"
  #   "zswap.enabled=1"
  #   "zswap.compressor=zstd"
  #   "zswap.zpool=zsmalloc"
  #   "zswap.max_pool_percent=50"
  # ];

  networking.hostName = "msi-nixos";

  nixpkgs.hostPlatform = "x86_64-linux";

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  system.stateVersion = "25.05";

}
