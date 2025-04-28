{
  name,
  SSID,
  PASSWORD,
  ...
}:

{
  networking.networkmanager = {
    ensureProfiles = {
      profiles = {
        ${name} = {
          connection = {
            id = SSID;
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
            ssid = SSID;
          };
          wifi-security = {
            auth-alg = "open";
            key-mgmt = "wpa-psk";
            psk = PASSWORD;
          };
        };
      };
    };
  };

}
