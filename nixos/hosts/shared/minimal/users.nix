{ config, pkgs, ... }:
{
  security.sudo.wheelNeedsPassword = false;
  sops.secrets."user_passwords/avie".neededForUsers = true;
  users.users.avie = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "docker"
    ];
    createHome = true;
    hashedPasswordFile = config.sops.secrets."user_passwords/avie".path;
  };
}
