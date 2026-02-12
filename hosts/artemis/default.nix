{
  inputs,
  userSettings,
  config,
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
  #     "users" # Allows any user to mount and unmount
  #     "nofail" # Prevent system from failing if this drive doesn't mount
  #   ];
  # };

  # nix.settings = {
  #   substituters = [
  #     "https://hyprland.cachix.org"
  #     "nixos-apple-silicon.cachix.org-1:8psDu5SA5dAD7qA0zMy5UT292TxeEPzIz8VVEr2Js20="
  #   ];
  #   trusted-substituters = [
  #     "https://hyprland.cachix.org"
  #     "nixos-apple-silicon.cachix.org-1:8psDu5SA5dAD7qA0zMy5UT292TxeEPzIz8VVEr2Js20="
  #   ];
  #   trusted-public-keys = [
  #     "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
  #     "nixos-apple-silicon.cachix.org-1:8psDu5SA5dAD7qA0zMy5UT292TxeEPzIz8VVEr2Js20="
  #   ];
  # };

  #General
  system.stateVersion = "25.05";
}
