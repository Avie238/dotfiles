{
  inputs,
  userSettings,
  config,
  lib,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    (userSettings.dotfilesDir + "/profiles/${userSettings.profile}/configuration.nix")
  ];

  #Boot
  # fileSystems."/home/avie/SSD" = {
  #   device = "/dev/disk/by-uuid/7f4c805b-8775-4bc3-9e20-216631de4d92";
  #   fsType = "ext4";
  #   options = [
  #     # If you don't have this options attribute, it'll default to "defaults"
  #     # boot options for fstab. Search up fstab mount options you can use
  #     "users" # Allows any user to mount and unmount/
  #     "nofail" # Prevent system from failing if this drive doesn't mount
  #   ];
  # };

  #General
  boot.loader = {
    systemd-boot.enable = lib.mkForce true;
  };

  system.stateVersion = "25.11";
}
