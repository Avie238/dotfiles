# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:

{

  options = {
    sops_config.enable = lib.mkEnableOption "enables use of sops_nix";
  };

  config = lib.mkIf config.sops_config.enable {

    #General
    sops = {
      defaultSopsFile = ../../secrets/secrets.yaml;
      defaultSopsFormat = "yaml";

      age.keyFile = (config.users.users.avie.home + "/.config/sops/age/keys.txt");
    };

    #Users
    sops.secrets."user_passwords/avie".neededForUsers = true;
    users.users.avie.hashedPasswordFile = config.sops.secrets."user_passwords/avie".path;

    #Network
    sops.secrets."wifi.env" = {
      owner = config.users.users.avie.name;
    };
    networking.networkmanager.ensureProfiles.environmentFiles = [ config.sops.secrets."wifi.env".path ];

  };

}
