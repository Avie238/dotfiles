{
  config,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ./graphics_asahi.nix
    ./boot.nix
    inputs.apple-silicon.nixosModules.apple-silicon-support
    ./../../nixosModules/desktop
  ];

  boot.supportedFilesystems = [ "apfs" ];
  networking.hostName = "avie-nixos";

  system.stateVersion = "25.05";
}
