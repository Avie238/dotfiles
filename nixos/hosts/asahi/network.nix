{ config, pkgs, ... }:
{
  networking.networkmanager = {
    enable = true;

    ensureProfiles = {
      environmentFiles = [ config.sops.secrets."wifi.env".path ];
      profiles = {

        wilczak_wifi = {
          connection = {
            id = "$WILCZAK_WIFI_SSID";
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
            ssid = "$WILCZAK_WIFI_SSID";
          };
          wifi-security = {
            auth-alg = "open";
            key-mgmt = "wpa-psk";
            psk = "$WILCZAK_WIFI_PASSWORD";
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
