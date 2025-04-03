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
    ./graphics_asahi.nix
    ./zswap.nix
    inputs.apple-silicon.nixosModules.apple-silicon-support
    ./../shared/desktop
  ];

  boot.binfmt.emulatedSystems = [ "x86_64-linux" ];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = false;
  };

  boot.kernelParams = [
    "apple_dcp.show_notch=1"
  ];

  networking.hostName = "avie-nixos";

  nixpkgs.hostPlatform = "aarch64-linux";

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  system.stateVersion = "25.05"; # Did you read the comment?

}
