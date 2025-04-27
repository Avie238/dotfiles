{...}: {
  imports = [
    (import ./networks/wpa-psk.nix {
      name = "sun2";
      SSID = "$SUN2_SSID";
      PASSWORD = "$SUN2_PASSWORD";
    })
    (import ./networks/wpa-psk.nix {
      name = "sun";
      SSID = "$SUN_SSID";
      PASSWORD = "$SUN_PASSWORD";
    })
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
      name = "iphoneHotspot";
      SSID = "$IPHONE_HOTSPOT_SSID";
      PASSWORD = "$IPHONE_HOTSPOT_PASSWORD";
    })
    (import ./networks/wpa-eap.nix {
      SSID = "eduroam";
      USERNAME = "$EDUORAM_USERNAME";
      PASSWORD = "$EDUORAM_PASSWORD";
    })
  ];

  networking.networkmanager = {
    enable = true;
  };
}
