{ config, lib, ... }:

{
  options = {
    sops.enable = lib.mkOption {
      default = true;
      type = lib.types.bool;
    };
  };

  config = lib.mkIf config.sops.enable {

    #General
    sops = {
      defaultSopsFile = ../../secrets/secrets.yaml;
      defaultSopsFormat = "yaml";

      age.keyFile = (config.users.users.avie.home + "/.config/sops/age/keys.txt");
    };

    #Users
    sops.secrets."user_passwords/avie".neededForUsers = true;
    users.users.avie.hashedPasswordFile = config.sops.secrets."user_passwords/avie".path;
    users.users.root.hashedPasswordFile = config.sops.secrets."user_passwords/avie".path;

    #Network
    sops.secrets."wifi.env" = {
      owner = config.users.users.avie.name;
    };
    networking.networkmanager.ensureProfiles.environmentFiles = [ config.sops.secrets."wifi.env".path ];

  };
}
