{
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ./../../nixosModules/desktop
    (import ./disko.nix { device = "/dev/nvme0n1"; })
  ];

  networking.hostName = "msi-nixos";

  system.stateVersion = "25.05";

  sops.age.keyFile = lib.mkForce "/persist/system/var/lib/sops-nix/keys.txt";

}
