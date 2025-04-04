{
  config,
  pkgs,
  lib,
  ...
}:
{

  security.sudo.wheelNeedsPassword = false;

  users.users.avie = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "docker"
    ];
    createHome = true;
  };

}
