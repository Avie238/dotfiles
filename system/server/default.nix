{
  lib,
  inputs,
  ...
}: {
  imports = [
    ./jellyfin.nix
  ];
  services.logind.lidSwitchExternalPower = "ignore";
}
