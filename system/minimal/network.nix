{...}: {
  imports = [
    (import ./networks/wpa-psk.nix {
      name = "home";
      SSID = "$HOME_SSID";
      PASSWORD = "$HOME_PASSWORD";
    })
    (import ./networks/wpa-psk.nix {
      name = "wilczak";
      SSID = "$WILCZAK_SSID";
      PASSWORD = "$WILCZAK_PASSWORD";
    })
    (import ./networks/wpa-psk.nix {
      name = "hotspot";
      SSID = "HOTSPOT_SSID";
      PASSWORD = "$HOTSPOT_PASSWORD";
    })
    (import ./networks/wpa-eap.nix {
      SSID = "eduroam";
      USERNAME = "$EDUORAM_USERNAME";
      PASSWORD = "$EDUORAM_PASSWORD";
    })
  ];

  networking = {
    networkmanager = {
      enable = true;
    };
    # nameservers = ["1.1.1.1"];
  };
}
