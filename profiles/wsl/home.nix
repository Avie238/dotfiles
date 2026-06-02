{
  lib,
  userSettings,
  ...
}: {
  imports = [
    (userSettings.dotfilesDir + "/user")
  ];

  discord.enable = false;
  openmw-dev.enable = lib.mkForce false;

  xdg.configFile."distrobox/distrobox.conf".text = ''
    container_additional_volumes="/nix:/nix /etc/ssl/certs/ca-bundle.crt:/etc/ssl/host-ca.crt:ro"
    container_manager_additional_flags="-e CURL_CA_BUNDLE=/etc/ssl/host-ca.crt -e SSL_CERT_FILE=/etc/ssl/host-ca.crt -e GIT_SSL_CAINFO=/etc/ssl/host-ca.crt"
    container_pre_init_hook="[ -f /etc/ssl/host-ca.crt ] && cat /etc/ssl/host-ca.crt >> /etc/ssl/certs/ca-certificates.crt || true; [ -f /etc/ssl/host-ca.crt ] && cat /etc/ssl/host-ca.crt >> /etc/pki/tls/certs/ca-bundle.crt || true"
    container_init_hook="[ -f /etc/ssl/host-ca.crt ] && cp /etc/ssl/host-ca.crt /etc/ca-certificates/trust-source/anchors/corporate.crt || true; [ -f /etc/ssl/host-ca.crt ] && cp /etc/ssl/host-ca.crt /etc/pki/ca-trust/source/anchors/corporate.crt || true; update-ca-trust extract || true"
  '';
}
