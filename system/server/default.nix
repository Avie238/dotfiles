{
  lib,
  inputs,
  ...
}: {
  imports = [
    ./jellyfin.nix
  ];
  services.logind.lidSwitchExternalPower = "ignore";
  services.openssh = {
    enable = true;
    ports = [22];
    settings = {
      PasswordAuthentication = true;
      AllowUsers = null;
      UseDns = true;
    };
  };
}
