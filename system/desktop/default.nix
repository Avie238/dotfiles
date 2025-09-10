{
  pkgs,
  userSettings,
  ...
}: {
  imports = [
    ./../minimal
    ./wm
    ./zswap.nix
    ./stylix.nix
    ./vm.nix
    ./vpn.nix
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

  services.samba-wsdd = {
    enable = true;
    openFirewall = true;
  };

  networking.firewall.enable = true;
  networking.firewall.allowPing = true;
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

  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
  };

  services.netbird.enable = true;
}
