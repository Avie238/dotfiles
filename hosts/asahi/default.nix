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
    ./boot.nix
    inputs.apple-silicon.nixosModules.apple-silicon-support
    ./../shared/desktop
  ];

  networking.hostName = "avie-nixos";

  system.stateVersion = "25.05";
}
