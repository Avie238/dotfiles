{ config, pkgs, ... }:
{
  networking.networkmanager = {
    enable = true;

    ensureProfiles = {
      environmentFiles = [ config.sops.secrets."wifi.env".path ];
      profiles = {
        home = {
          connection = {
            id = "$HOME_SSID";
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
            ssid = "$HOME_SSID";
          };
          wifi-security = {
            auth-alg = "open";
            key-mgmt = "wpa-psk";
            psk = "$HOME_PASSWORD";
          };
        };
        wilczak = {
          connection = {
            id = "$WILCZAK_SSID";
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
            ssid = "$WILCZAK_SSID";
          };
          wifi-security = {
            auth-alg = "open";
            key-mgmt = "wpa-psk";
            psk = "$WILCZAK_PASSWORD";
          };
        };
        iphoneHotspot = {
          connection = {
            id = "$IPHONE_HOTSPOT_SSID";
            permissions = "";
            type = "wifi";
          };
          wifi = {
            mode = "infrastructure";
            ssid = "$IPHONE_HOTSPOT_SSID";
          };
          wifi-security = {
            auth-alg = "open";
            key-mgmt = "wpa-psk";
            psk = "$IPHONE_HOTSPOT_PASSWORD";
          };
          ipv4.method = "auto";
          ipv6 = {
            addr-gen-mode = "default";
            method = "auto";
          };
        };
      };
    };
  };

}
