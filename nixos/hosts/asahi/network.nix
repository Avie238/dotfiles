{ config, pkgs, ... }:
{
  networking.networkmanager.ensureProfiles.profiles = {
    wilczak_wifi = {
      connection = {
        id = "may_the_force_be_with_you";
        permissions = "";
        type = "wifi";
      };
      ipv4.method = "auto";
      ipv6 = {
        addr-gen-mode = "default";
        method = "auto";
      };
      wifi = {
        mode = "infrastructure";
        ssid = "may_the_force_be_with_you";
      };
      wifi-security = {
        auth-alg = "open";
        key-mgmt = "wpa-psk";
        psk = "ghf56^agtg_7";
      };
    };
  };

}
