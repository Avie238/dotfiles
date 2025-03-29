{ config, pkgs, ... }:
{
  networking.networkmanager = {
    enable = true;
    ensureProfiles.profiles = {
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
      iphoneHotspot = {
        connection = {
          id = "Ania’s iPhone";
          permissions = "";
          type = "wifi";
        };
        wifi = {
          mode = "infrastructure";
          ssid = "Ania’s iPhone";
        };
        wifi-security = {
          auth-alg = "open";
          key-mgmt = "wpa-psk";
          psk = "Anka1234";
        };
        ipv4.method = "auto";
        ipv6 = {
          addr-gen-mode = "default";
          method = "auto";
        };
      };
    };
  };

}
