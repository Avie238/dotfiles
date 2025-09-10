{
  lib,
  config,
  ...
}: {
  options = {
    vpn.enable = lib.mkOption {
      default = true;
      type = lib.types.bool;
    };
  };

  config = lib.mkIf config.vpn.enable {
    networking.firewall = {
      allowedUDPPorts = [config.networking.wg-quick.interfaces.wg0.listenPort];
    };

    networking.wg-quick.interfaces = {
      wg0 = {
        # [Interface] section -> Address
        address = ["10.2.0.2/32"];

        # [Interface] section -> DNS
        dns = ["10.2.0.1"];

        # [Peer] section -> Endpoint:port
        listenPort = 51820;

        # Path to the private key file.
        privateKeyFile =
          config.sops.secrets."proton_vpn.key".path;

        peers = [
          {
            # [Peer] section -> PublicKey
            publicKey = "J/ZzG0F1/adsnl//WNoHQVmUL+eJcYLFwdnHsYvbjC0=";
            # [Peer] section -> AllowedIPs
            allowedIPs = ["0.0.0.0/0" "::/0"];
            # [Peer] section -> Endpoint:port
            endpoint = "79.127.164.65:51820";
            persistentKeepalive = 25;
          }
        ];
      };
    };
  };
}
