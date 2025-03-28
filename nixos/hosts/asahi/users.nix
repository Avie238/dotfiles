{ config, pkgs, ... }:
{
  users.users.avie = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "docker"
    ];
    createHome = true;
    password = "ania123";
  };
}
