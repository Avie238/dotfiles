{
  lib,
  inputs,
  userSettings,
  config,
  pkgs,
  ...
}:
#let
# zfsCompatibleKernelPackages =
#   lib.filterAttrs (
#     name: kernelPackages:
#       (builtins.match "linux_[0-9]+_[0-9]+" name)
#       != null
#       && (builtins.tryEval kernelPackages).success
#       && (!kernelPackages.${config.boot.zfs.package.kernelModuleAttribute}.meta.broken)
#   )
#   pkgs.linuxKernel.packages;
# latestKernelPackage = lib.last (
#   lib.sort (a: b: (lib.versionOlder a.kernel.version b.kernel.version)) (
#     builtins.attrValues zfsCompatibleKernelPackages
#   )
# );
#in
{
  imports = [
    ./hardware-configuration.nix
    # (import ./disko.nix {device = "/dev/sda";})
    (userSettings.dotfilesDir + "/profiles/${userSettings.profile}/configuration.nix")
    # inputs.disko.nixosModules.default
  ];

  boot.initrd.kernelModules = ["dm_mod"];

  sops.age.keyFile = lib.mkForce "/var/lib/sops-nix/keys.txt";
  #boot.kernelPackages = latestKernelPackage;

  # boot.supportedFilesystems = ["zfs"];
  # networking.hostId = "0a158abe";
  # boot.zfs.extraPools = ["data"];

  system.stateVersion = "26.05";
}
