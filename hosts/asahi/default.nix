{
  config,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ./asahi.nix
    ./boot.nix
    inputs.apple-silicon.nixosModules.apple-silicon-support
    ./../../nixosModules/desktop
  ];
  config = {
    boot.supportedFilesystems = [ "apfs" ];
    networking.hostName = "avie-nixos";
    system.stateVersion = "25.05";
  };
}
