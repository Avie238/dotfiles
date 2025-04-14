{
  SSID,
  USERNAME,
  PASSWORD,
  ...
}:

{
  networking.networkmanager = {
    ensureProfiles = {
      profiles = {
        ${SSID} = {
          connection = {
            id = SSID;
            permissions = "";
            type = "wifi";
            interface-name = "wlp1s0f0";
          };
          wifi = {
            mode = "infrastructure";
            ssid = SSID;
          };
          wifi-security = {
            auth-alg = "open";
            key-mgmt = "wpa-eap";
          };
          "802-1x" = {
            eap = "peap";
            identity = USERNAME;
            password = PASSWORD;
            phase2-auth = "mschapv2";
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
