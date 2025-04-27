{
  lib,
  inputs,
  userSettings,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    (import ./disko.nix {device = "/dev/nvme0n1";})
    (userSettings.dotfilesDir + "/profiles/desktop/configuration.nix")
    inputs.disko.nixosModules.default
    ./impermanence.nix
  ];

  boot.binfmt.emulatedSystems = ["aarch64-linux"];

  networking.hostName = "msi-nixos";

  system.stateVersion = "25.05";

  sops.age.keyFile = lib.mkForce "/var/lib/sops-nix/keys.txt";
}
