{
  lib,
  inputs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./../../nixosModules/desktop
    (import ./disko.nix {device = "/dev/nvme0n1";})
    inputs.disko.nixosModules.default
    ./impermanence.nix
  ];

  networking.hostName = "msi-nixos";

  system.stateVersion = "25.05";

  sops.age.keyFile = lib.mkForce "/var/lib/sops-nix/keys.txt";
}
