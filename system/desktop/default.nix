{
  pkgs,
  userSettings,
  lib,
  config,
  ...
}: let
in {
  imports = [
    ./../minimal
    ./wm
    ./zswap.nix
    ./stylix.nix
    ./vm.nix
    ./vpn.nix
    ./file_manager
  ];

  hardware.graphics = {
    enable = true;
  };

  virtualisation.docker.enable = true;

  services.samba = {
    enable = true;
    settings.global.security = "user";
    openFirewall = true;
  };
  networking.nftables.enable = true;

  services.samba-wsdd = {
    enable = true;
    openFirewall = true;
  };

  networking.firewall = {
    enable = true;
    allowPing = true;
  };
  services.printing.enable = true;
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  services.logind.settings.Login.HandlePowerKey = "suspend";

  services.flatpak.enable =
    if userSettings.wm == "none"
    then false
    else true;

  services.netbird.enable = true;
  vpn.enable = false;
}
